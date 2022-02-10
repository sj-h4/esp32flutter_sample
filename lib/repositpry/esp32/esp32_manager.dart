import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:async';

import 'esp32_data.dart';
import 'esp32_profile.dart';

class Esp32Repository {
  // TODO: singletonにする
  final String deviceName = Esp32NameProfile.ESP32_NAME;
  final String serviceUuid = Esp32ServicesProfile.ESP32_SERVICE;
  final String characteristicUuid =
      Esp32CharacteristicProfile.ESP32DATA_CHARACTERISTIC;
  FlutterBlue flutterBlue = FlutterBlue.instance;

  late BluetoothDevice targetDevice;
  late BluetoothCharacteristic esp32Characteristic;
  late BluetoothService esp32Service;

  final controller = StreamController<Esp32Data>();
  Esp32Data _esp32 = Esp32Data(deviceStatus: "waiting", isConnected: false);

  double altitude = 0.0;
  double rotation = 0.0;
  double airspeed = 0.0;
  double pitch = 0.0;
  double roll = 0.0;
  String deviceStatus = "waiting";
  bool isConnected = false;
  Color pitchColor = Colors.blue;
  double trim = 0.0;
  bool isPressed = false;
  double elevator = 0.0;
  double rudder = 0.0;

  void dispose() {
    controller.close();
  }

  void startScan() {
    // TODO: Bluetoothのオンオフチェック
    flutterBlue.startScan(timeout: Duration(seconds: 4));
    print("deviceStatus: connecting");
    if (this.isConnected) {
      disconnectDevice();
      return;
    }

    // Listen to scan results
    flutterBlue.scanResults.listen(
      (results) {
        // do something with scan results
        for (ScanResult r in results) {
          print('device name: ${r.device.name}');

          if (r.device.name == this.deviceName) {
            this.targetDevice = r.device;
            flutterBlue.stopScan();
            break;
          }
        }
      },
    );
  }

  void connectToDevice() async {
    print("start connecting");
    await this.targetDevice.connect();
    this.targetDevice.isDiscoveringServices.forEach((element) {
      print("is discovering $element");
    });
  }

  void disconnectDevice() {
    this.targetDevice.disconnect();
    flutterBlue.stopScan();
    print("disconnected");
    _esp32 = _esp32.copyWith(isConnected: false, deviceStatus: "waiting");
    controller.sink.add(_esp32);
  }

  Future<bool> discoverServices() async {
    List<BluetoothService>? services =
        await this.targetDevice.discoverServices();
    for (BluetoothService s in services) {
      print("service UUID: ${s.uuid}");
      if (s.uuid.toString() == serviceUuid) {
        esp32Service = s;
        return true;
      }
    }
    print("cannot find service");
    return false;
  }

  Future<bool> discoverCharacteristics() async {
    for (BluetoothCharacteristic charactaristic
        in esp32Service.characteristics) {
      print(charactaristic.uuid.toString());
      if (charactaristic.uuid.toString() == characteristicUuid) {
        esp32Characteristic = charactaristic;
        _esp32 = _esp32.copyWith(
            deviceStatus: "cannot discover services", isConnected: false);
        controller.sink.add(_esp32);
        return true;
      }
    }
    print("cannot find characteristic");
    return false;
  }

  void recieveNotification() async {
    print("start notify");
/*
0xAAAABBBBCCCCDDDDDDEEEEEEFFFFGGHHII

AAAA:高度計のデータ
x1 cm
例: 0xAAAA = 0x0051なら81 cm

BBBB:回転数計のデータ
x0.1 rpm
例: 0xBBBB = 0x0051なら8.1 rpm

CCCC:気速計のデータ
x0.001 m/s
例: 0xCCCC = 0x0051なら0.081 m/s

DDDDDD:ピッチのデータ
x0.1 deg
先頭2バイトは符号を表す。0x00は+, 0xffは-。
例: 0xDDDDDD = 0x000051なら+8.1 deg
　 0xDDDDDD = 0xff0051なら-8.1 deg

EEEEEE:ロールのデータ
x0.1 deg
先頭2バイトは符号を表す。0x00は+, 0xffは-。
例: 0xEEEEEE = 0x000051なら+8.1 deg
　 0xEEEEEE = 0xff0051なら-8.1 deg

FFFF:トリム量のデータ
x1 deg
先頭2バイトは符号を表す。0x00は+, 0xffは-。
例: 0xFFFF = 0x0021なら+33 deg
　 0xFFFF = 0xff21なら-33 deg

GG:画面切り替えのデータ
例: 0xGG = 0x00ならそのまま 　 0xGG = 0xffなら切り替え

HH:エレベータ操作量のデータ
0(0x00)から180(0xB4)までの値を返す。デフォルトは90(0x5A)。
例: 0xHH = 0x00ならアップ最大(ヌンチャク上傾け)
　 0xHH = 0xB4ならダウン最大(ヌンチャク下傾け)

II:ラダー操作量のデータ
0(0x00)から180(0xB4)までの値を返す。デフォルトは90(0x5A)。
例: 0xII = 0x00なら右最大(ヌンチャク右傾け)
　 0xII = 0xB4なら左最大(ヌンチャク左傾け)
*/
    await Future.delayed(new Duration(milliseconds: 500));
    await esp32Characteristic.setNotifyValue(true);
    esp32Characteristic.value.listen((value) async {
      altitude = (value[0] * 256 + value[1]) / 100; // 単位をmに変換
      rotation = (value[2] * 256 + value[3]) / 10;
      rotation = rotation * 90 / 140; // ペラの回転数をクランクの回転数に変換
      airspeed = (value[4] * 256 + value[5]) / 1000;
      print('$value');
      pitch = (value[7] * 256 + value[8]) / 10;
      if (value[6] == 0) {
        pitch *= -1;
      }
      roll = (value[10] * 256 + value[11]) / 10;
      if (value[9] == 255) {
        roll *= -1;
      }

      trim = (value[13]).toDouble();
      if (value[12] == 255) {
        trim *= -1;
      }

      if (value[14] == 255) {
        isPressed = true;
      } else {
        isPressed = false;
      }
      elevator = value[15].toDouble();
      rudder = value[16].toDouble();

      // ピッチに応じて画面の色を変える
      if (pitch >= 4) {
        pitchColor = Colors.red;
      } else if (pitch >= -1) {
        pitchColor = Colors.yellow;
      } else {
        pitchColor = Colors.lightBlue;
      }
      _esp32 = _esp32.copyWith(
          altitude: altitude,
          rotation: rotation,
          airspeed: airspeed,
          pitch: pitch,
          roll: roll,
          pitchColor: pitchColor,
          trim: trim,
          isPressed: isPressed,
          elevator: elevator,
          rudder: rudder);
      controller.sink.add(_esp32);
    });
  }
}

class Esp32Manager extends StateNotifier<Esp32Data> {
  Esp32Manager()
      : super(Esp32Data(
            altitude: 0.0,
            rotation: 0.0,
            airspeed: 0.0,
            pitch: 0.0,
            roll: 0.0,
            deviceStatus: "No Device",
            isConnected: false,
            pitchColor: Colors.lightBlue,
            trim: 0,
            isPressed: false,
            elevator: 90,
            rudder: 90));
  Esp32Repository esp32repository = Esp32Repository();

  void disconnect() {
    esp32repository.disconnectDevice();
  }

  void connect() async {
    esp32repository.startScan();
    await Future.delayed(Duration(milliseconds: 500));
    esp32repository.connectToDevice();
    var serviceStatus = await esp32repository.discoverServices();
    if (serviceStatus) {
      var characteristicStatus =
          await esp32repository.discoverCharacteristics();
      if (characteristicStatus) {
        notify();
      } else {
        print("cannot discover characteristics");
        state = state.copyWith(
            deviceStatus: "cannot discover characteristics",
            isConnected: false);
      }
    } else {
      print("cannot discover services");
      state = state.copyWith(
          deviceStatus: "cannot discover services", isConnected: false);
    }
  }

  void notify() {
    print("start nt");
    esp32repository.recieveNotification();
    esp32repository.controller.stream.listen((event) {
      state = state.copyWith(
        altitude: event.altitude,
        rotation: event.rotation,
        airspeed: event.airspeed,
        pitch: event.pitch,
        roll: event.roll,
        pitchColor: event.pitchColor,
        trim: event.trim,
        isPressed: event.isPressed,
        elevator: event.elevator,
        rudder: event.rudder,
      );
    });
  }

  void sendData() {
    esp32repository.controller.stream.listen((event) {
      print(event.altitude);
      sleep(Duration(seconds: 1));
    });
  }
}

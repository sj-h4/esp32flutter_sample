import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:async';

import 'esp32_data.dart';
import 'esp32_profile.dart';

class Esp32Manager extends StateNotifier<Esp32Data> {
  // TODO: singletonにする
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
  final String deviceName = Esp32NameProfile.ESP32_NAME;
  final String serviceUuid = Esp32ServicesProfile.ESP32_SERVICE;
  final String characteristicUuid =
      Esp32CharacteristicProfile.ESP32DATA_CHARACTERISTIC;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  //SettingState settingState;

  BluetoothDevice? targetDevice;
  late BluetoothCharacteristic espCharacteristic;

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

  @override
  void dispose() {
    print('esp32manager is disposed');
    super.dispose();
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
          deviceStatus = "scanning";
          state = state.copyWith(deviceStatus: "scanning");

          if (r.device.name == this.deviceName) {
            print("device is found");
            this.isConnected = true;
            state = state.copyWith(isConnected: true);
            this.targetDevice = r.device;
            connectToDevice();
            flutterBlue.stopScan();
            break;
          }
        }
      },
    );
  }

  void connectToDevice() async {
    print("start connecting");
    if (this.targetDevice == null) {
      deviceStatus = "targetDevide is null";
      state = state.copyWith(deviceStatus: "targetDevide is null");
      return;
    }

    await this.targetDevice?.connect();
    deviceStatus = "Connected: ${targetDevice?.name}";
    state = state.copyWith(deviceStatus: "Connected: ${targetDevice?.name}");
    print('connected');
    this.targetDevice?.isDiscoveringServices.forEach((element) {
      print("is discovering $element");
    });
    discoverServices();
  }

  void disconnectDevice() {
    if (this.targetDevice == null) return;

    this.targetDevice?.disconnect();
    this.isConnected = false;
    flutterBlue.stopScan();
    state = state.copyWith(isConnected: false);

    deviceStatus = "disconnected";
    state = state.copyWith(deviceStatus: "disconnected");
    print("disconnected");
  }

  void discoverServices() async {
    if (this.targetDevice == null) return;
    //print("discovering");
    this.targetDevice?.isDiscoveringServices.forEach((element) {
      //print("is discovering $element");
    });

    List<BluetoothService>? services =
        await this.targetDevice?.discoverServices();
    for (BluetoothService s in services!) {
      print("service UUID: ${s.uuid}");
      if (s.uuid.toString() == serviceUuid) {
        s.characteristics.forEach((charactaristic) {
          print(charactaristic.uuid.toString());

          if (charactaristic.uuid.toString() == characteristicUuid) {
            espCharacteristic = charactaristic;
            print("connected service");
            _recieveNotification();
          } else {
            print("cannot find characteristic");
          }
        });
      } else {
        print("cannot find service");
      }
    }
  }

  void _recieveNotification() async {
    print("start notify");
    if (this.targetDevice == null) return;
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
    await espCharacteristic.setNotifyValue(true);
    espCharacteristic.value.listen((value) async {
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

      state = state.copyWith(
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
    });
  }

/*
  Future<void> sendData() async {
    String baseTfName = settingState.baseTfName;
    int flightNum = settingState.flightNum;
    String tfName = baseTfName + flightNum.toString();
    while (settingState.isSending) {
      final apiCliant = ApiCliant();

      await Future.delayed(new Duration(milliseconds: 500));
      apiCliant.postData(tfName, "altitude", altitude);
      apiCliant.postData(tfName, "rotation", rotation);
      apiCliant.postData(tfName, "airspeed", airspeed);
      await Future.delayed(new Duration(milliseconds: 500));
      apiCliant.postData(tfName, "pitch", pitch);
      apiCliant.postData(tfName, "roll", roll);
    }
  }
  */
}

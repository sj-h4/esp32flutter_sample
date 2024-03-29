import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'repositories.dart';
import 'dart:async';
import 'package:esp32flutter_sample/data/entities/esp32.dart';
import 'package:esp32flutter_sample/data/entities/esp32_profile.dart';

final esp32RepositoryProvider = Provider<Esp32Repository>((ref) {
  return Esp32Repository();
});
final scanResultsProvider = StreamProvider((ref) {
  return ref.watch(esp32RepositoryProvider).startScan();
});
final esp32InScanResultProvider = Provider<BluetoothDevice?>((ref) {
  final scanResults = ref.watch(scanResultsProvider.stream);
  BluetoothDevice? esp32;
  scanResults.listen((results) {
    for (ScanResult result in results) {
      if (result.device.name == 'ESP32') {
        esp32 = result.device;
      }
    }
  });
  return esp32;
});
final esp32DeviceProvider = StateProvider<BluetoothDevice?>((ref) {
  return null;
});
final esp32StateProvider = StreamProvider((ref) {
  final esp32Device = ref.watch(esp32DeviceProvider);
  return esp32Device!.state;
});
final isConnectedProvider = FutureProvider<bool>((ref) async {
  final esp32State = await ref.watch(esp32StateProvider.future);
  if (esp32State == BluetoothDeviceState.connected) {
    return true;
  }
  return false;
});

class Esp32Repository {
  Esp32Repository() : super();

  final esp32StreamController = StreamController<Esp32>.broadcast();
  Esp32 esp32 = const Esp32(deviceStatus: "waiting", isConnected: false);
  final String deviceName = Esp32NameProfile.esp32Name;
  final String serviceUuid = Esp32ServicesProfile.esp32Service;
  final String characteristicUuid =
      Esp32CharacteristicProfile.esp32Characteristic;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  late BluetoothDevice targetDevice;
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

  Future<void> dispose() async {
    esp32StreamController.close();
    debugPrint('esp32 repository is closed');
  }

  Future<void> disconnectDevice() async {
    esp32 = esp32.copyWith(deviceStatus: "waiting", isConnected: false);
    if (!esp32StreamController.isClosed) {
      esp32StreamController.sink.add(esp32);
    }
    targetDevice.disconnect();
    isConnected = false;
    flutterBlue.stopScan();
    debugPrint("disconnected");
  }

  Stream<List<ScanResult>> startScan() {
    flutterBlue.startScan(timeout: const Duration(seconds: 4));
    esp32 = esp32.copyWith(deviceStatus: "scanning", isConnected: false);
    /*if (!esp32StreamController.isClosed) {
      esp32StreamController.sink.add(esp32);
    }*/
    return flutterBlue.scanResults;
    /*
    // Listen to scan results
    flutterBlue.scanResults.listen(
      (results) {
        // do something with scan results
        for (ScanResult r in results) {
          debugPrint('device name: ${r.device.name}');
          deviceStatus = "scanning";

          if (r.device.name == deviceName) {
            debugPrint("device is found");
            isConnected = true;
            targetDevice = r.device;
            connectToDevice();
            flutterBlue.stopScan();
            break;
          }
        }
      },
    );
    */
  }

  Future<void> connectToEsp32(BluetoothDevice device) async {
    await device.connect();
    debugPrint('connected');
    // discoverServices();
  }

  Future<BluetoothCharacteristic?> discoverServices(
      BluetoothDevice device) async {
    List<BluetoothService>? services = await device.discoverServices();
    for (BluetoothService s in services) {
      if (s.uuid.toString() == serviceUuid) {
        for (var charactaristic in s.characteristics) {
          debugPrint(charactaristic.uuid.toString());
          if (charactaristic.uuid.toString() == characteristicUuid) {
            espCharacteristic = charactaristic;
            debugPrint("connected service");
            /*
            esp32 = esp32.copyWith(
                deviceStatus: "Connected: ${targetDevice.name}",
                isConnected: true);
            if (!esp32StreamController.isClosed) {
              esp32StreamController.sink.add(esp32);
            }
            */
            return charactaristic;
          } else {
            debugPrint("cannot find characteristic");
          }
        }
      } else {
        debugPrint("cannot find service");
      }
    }
    return null;
  }

  Stream<List<int>> recieveNotification(
      BluetoothCharacteristic characteristic) async* {
    await characteristic.setNotifyValue(true);
    yield* characteristic.value;
  }

  Esp32 esp32Raw2Esp32(value) {
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
    altitude = (value[0] * 256 + value[1]).toDouble();
    rotation = (value[2] * 256 + value[3]).toDouble();
    airspeed = (value[4] * 256 + value[5]).toDouble();
    pitch = (value[7] * 256 + value[8]).toDouble();
    if (value[6] == 0) {
      pitch *= -1;
    }
    roll = (value[10] * 256 + value[11]).toDouble();
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
/*
    // ピッチに応じて画面の色を変える
    if (pitch >= 4) {
      pitchColor = Colors.red;
    } else if (pitch >= -1) {
      pitchColor = Colors.yellow;
    } else {
      pitchColor = Colors.lightBlue;
    }
*/
    return Esp32(
      altitude: altitude,
      rotation: rotation,
      airspeed: airspeed,
      pitch: pitch,
      roll: roll,
      pitchColor: pitchColor,
      trim: trim,
      isPressed: isPressed,
      elevator: elevator,
      rudder: rudder,
    );
  }
}

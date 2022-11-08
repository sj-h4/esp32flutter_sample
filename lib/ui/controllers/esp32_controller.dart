import 'controllers.dart';
import 'package:esp32flutter_sample/data/entities/esp32.dart';
import 'package:esp32flutter_sample/data/repositories/esp32_repository.dart';

final esp32ControllerProvider = StateNotifierProvider<Esp32Controller, Esp32>(
    (ref) => Esp32Controller(ref));

class Esp32Controller extends StateNotifier<Esp32> {
  Esp32Controller(this.ref)
      : super(const Esp32(
          altitude: 0,
          rotation: 0,
          airspeed: 0,
          pitch: 0,
          roll: 0,
          pitchColor: Colors.lightBlue,
          trim: 0,
          isPressed: false,
          elevator: 0,
          rudder: 0,
          deviceStatus: "waiting",
          isConnected: false,
        ));

  Esp32Repository esp32repository = Esp32Repository();
  Ref ref;

  void getEsp32Data() async {
    final esp32InScanResult = ref.watch(esp32InScanResultProvider);
    ref.watch(esp32DeviceProvider.notifier).state = esp32InScanResult;
    final characteristic =
        await esp32repository.discoverServices(esp32InScanResult!);
    esp32repository.recieveNotification(characteristic!).listen((bleRawData) {
      final esp32Data = esp32repository.esp32Raw2Esp32(bleRawData);
      state = state.copyWith(
        altitude: esp32Data.altitude,
        rotation: esp32Data.rotation,
        airspeed: esp32Data.airspeed,
        pitch: esp32Data.pitch,
        roll: esp32Data.roll,
        pitchColor: esp32Data.pitchColor,
        trim: esp32Data.trim,
        isPressed: esp32Data.isPressed,
        elevator: esp32Data.elevator,
        rudder: esp32Data.rudder,
      );
    });
  }

  void disconnectEsp32() {
    debugPrint("disconnectEsp32");
    esp32repository.disconnectDevice();
  }
}

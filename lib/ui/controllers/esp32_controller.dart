import 'controllers.dart';
import 'package:esp32flutter_sample/data/entities/esp32.dart';
import 'package:esp32flutter_sample/data/repositories/esp32_repository.dart';

final esp32ControllerProvider =
    StateNotifierProvider<Esp32Controller, Esp32>((ref) => Esp32Controller());

class Esp32Controller extends StateNotifier<Esp32> {
  Esp32Controller()
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

  void getEsp32Data() {
    esp32repository.esp32StreamController.stream.listen((event) {
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
        deviceStatus: event.deviceStatus,
        isConnected: event.isConnected,
      );
    });
    esp32repository.startScan();
  }

  void disconnectEsp32() {
    debugPrint("disconnectEsp32");
    esp32repository.disconnectDevice();
  }
}

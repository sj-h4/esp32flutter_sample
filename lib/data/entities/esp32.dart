import 'entities.dart';
import 'package:flutter/foundation.dart';

part 'esp32.freezed.dart';

@freezed
class Esp32 with _$Esp32 {
  const factory Esp32({
    double? altitude,
    double? rotation,
    double? airspeed,
    double? pitch,
    double? roll,
    String? deviceStatus,
    @Default(false) bool isConnected,
    Color? pitchColor,
    double? trim,
    bool? isPressed,
    double? elevator,
    double? rudder,
  }) = _Esp32;
}

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'esp32_data.freezed.dart';

@freezed
class Esp32Data with _$Esp32Data {
  const factory Esp32Data({
    double? altitude,
    double? rotation,
    double? airspeed,
    double? pitch,
    double? roll,
    String? deviceStatus,
    bool? isConnected,
    Color? pitchColor,
    double? trim,
    bool? isPressed,
    double? elevator,
    double? rudder,
  }) = _Esp32Data;
}

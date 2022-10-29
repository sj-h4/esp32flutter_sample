import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:esp32flutter_sample/ui/widgets/elevator.dart';
import 'package:esp32flutter_sample/ui/widgets/esp32_button.dart';
import 'package:esp32flutter_sample/ui/widgets/rudder.dart';
import 'package:esp32flutter_sample/ui/widgets/airspeed.dart';
import 'package:esp32flutter_sample/ui/widgets/altitude.dart';
import 'package:esp32flutter_sample/ui/widgets/atitude_indicator.dart';
import 'package:esp32flutter_sample/ui/widgets/esp32_status.dart';
import 'package:esp32flutter_sample/ui/widgets/power.dart';
import 'package:esp32flutter_sample/ui/widgets/rotation.dart';
import 'package:esp32flutter_sample/ui/controllers/esp32_controller.dart';

class DataPage extends HookConsumerWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final esp32Data = ref.watch(esp32ControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESP32 DATA'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Airspeed(esp32Data.airspeed!),
          Altitude(esp32Data.altitude!),
          Rotation(esp32Data.rotation!),
          AtitudeIndicator(esp32Data.pitch!, esp32Data.roll!),
          Rudder(esp32Data.rudder!),
          Elevator(esp32Data.elevator!, esp32Data.trim!),
          ButtonPressed(esp32Data.isPressed!),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "ESP32",
                style: Theme.of(context).textTheme.headline6,
              ),
              const Esp32Status(),
              const Esp32Button(),
            ],
          ),
        ],
      ),
    );
  }
}

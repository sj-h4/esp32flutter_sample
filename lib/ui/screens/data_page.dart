import 'package:esp32flutter_sample/ui/widgets/elevator.dart';
import 'package:esp32flutter_sample/ui/widgets/esp32_button.dart';
import 'package:esp32flutter_sample/ui/widgets/rudder.dart';
import 'package:flutter/material.dart';
import 'package:esp32flutter_sample/ui/widgets/airspeed.dart';
import 'package:esp32flutter_sample/ui/widgets/altitude.dart';
import 'package:esp32flutter_sample/ui/widgets/atitude_indicator.dart';
import 'package:esp32flutter_sample/ui/widgets/esp32_status.dart';
import 'package:esp32flutter_sample/ui/widgets/power.dart';
import 'package:esp32flutter_sample/ui/widgets/rotation.dart';

class DataPage extends StatelessWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESP32 DATA'),
      ),
      body: const _BuildSettingPage(),
    );
  }
}

class _BuildSettingPage extends StatelessWidget {
  const _BuildSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        Airspeed(),
        Altitude(),
        Rotation(),
        AtitudeIndicator(),
        Rudder(),
        Elevator(),
        Power(),
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
    );
  }
}

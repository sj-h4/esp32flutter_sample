import 'package:esp32flutter_sample/ui/widgets/elevator.dart';
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Airspeed(),
          Altitude(),
          Rotation(),
          AtitudeIndicator(),
          Rudder(),
          Elevator(),
          Esp32Status(),
        ],
      ),
    );
  }
}

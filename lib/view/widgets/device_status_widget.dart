import 'package:esp32flutter_sample/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

class DeviceStatusWidget extends HookWidget {
  const DeviceStatusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final esp32State = useProvider(esp32Provider);

    return Center(
      child: Column(
        children: [
          Text('DeviceStatus: ${esp32State.deviceStatus}'),
        ],
      ),
    );
  }
}

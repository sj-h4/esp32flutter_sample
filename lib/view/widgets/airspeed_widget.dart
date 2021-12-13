import 'package:esp32flutter_sample/repositpry/provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

class AirspeedWidget extends HookWidget {
  const AirspeedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final esp32State = useProvider(esp32Provider);
    final airspeedState = useProvider(airspeedProvider);

    return Center(
      child: Column(
        children: [
          Text('Airspeed: ${airspeedState.state}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                child: const Text('connect'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (esp32State.isConnected!) {
                    context.read(esp32Provider.notifier).disconnectDevice();
                  } else {
                    context.read(esp32Provider.notifier).startScan();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

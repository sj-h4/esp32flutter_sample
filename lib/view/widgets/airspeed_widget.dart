import 'package:esp32flutter_sample/repositpry/provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

class AirspeedWidget extends HookWidget {
  const AirspeedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final airspeedState = useProvider(airspeedProvider);
    final esp32IsConnected = useProvider(esp32IsConnecetedProvider);

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
                  context.read(esp32Provider.notifier).connect();
                },
              ),
            ],
          ),
          ElevatedButton(
                child: const Text('send'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  context.read(esp32Provider.notifier).sendData();
                },
              ),
        ],
      ),
    );
  }
}

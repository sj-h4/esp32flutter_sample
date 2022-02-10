import 'package:flutter/material.dart';
import 'package:esp32flutter_sample/ui/widgets/esp32_button.dart';
import 'package:esp32flutter_sample/ui/widgets/esp32_status.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: const _BuildSettingPage(),
    );
  }
}

class _BuildSettingPage extends StatelessWidget {
  const _BuildSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(10), children: <Widget>[
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
    ]);
  }
}

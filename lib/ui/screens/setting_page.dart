import 'package:flutter/material.dart';

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
      Text(
        "This is setting page.",
        style: Theme.of(context).textTheme.headline6,
      ),
    ]);
  }
}

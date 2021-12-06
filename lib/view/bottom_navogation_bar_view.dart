import 'package:esp32flutter_sample/main.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'dataview.dart';
import 'settings_view.dart';

class BottomNavigationBarView extends HookWidget {
  final _views = [DataView(), SettingsView()];

  @override
  Widget build(BuildContext context) {
    final tabType = useProvider(tabTypeProvider);
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.white),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.airplanemode_active),
              label: 'Data',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
          ],
          onTap: (int selectIndex) {
            tabType.state = TabType.values[selectIndex];
          },
          currentIndex: tabType.state.index,
        ),
        body: _views[tabType.state.index],
      ),
    );
  }
}

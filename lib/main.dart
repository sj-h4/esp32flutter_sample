import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'view/bottom_navogation_bar_view.dart';

final tabTypeProvider =
    AutoDisposeStateProvider<TabType>((ref) => TabType.data);

enum TabType {
  data,
  setting,
}

void main() {
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test app for ESP32',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      routes: <String, WidgetBuilder>{
        '/': (_) => BottomNavigationBarView(),
      },
    );
  }
}

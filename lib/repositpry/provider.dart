import 'package:esp32flutter_sample/repositpry/esp32/esp32_manager_singleton.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'esp32/esp32_data.dart';
import 'esp32/esp32_manager.dart';

final esp32Provider =
    StateNotifierProvider<Esp32Manager, Esp32Data>((_) => Esp32Manager());
final airspeedProvider =
    StateProvider((ref) => Esp32ManagerSingleton().airspeed);
final esp32IsConnecetedProvider =
    StateProvider((ref) => Esp32ManagerSingleton().isConnected);
final esp32DeviceStatusProvider =
    StateProvider((ref) => Esp32ManagerSingleton().deviceStatus);

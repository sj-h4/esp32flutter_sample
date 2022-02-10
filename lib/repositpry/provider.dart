import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'esp32/esp32_data.dart';
import 'esp32/esp32_manager.dart';

final esp32Provider =
    StateNotifierProvider<Esp32Manager, Esp32Data>((_) => Esp32Manager());
final airspeedProvider =
    StateProvider((ref) => ref.watch(esp32Provider).airspeed);
final esp32IsConnecetedProvider =
    StateProvider((ref) => ref.watch(esp32Provider).isConnected);
final esp32DeviceStatusProvider =
    StateProvider((ref) => ref.watch(esp32Provider).deviceStatus);

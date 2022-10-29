import 'package:esp32flutter_sample/data/repositories/esp32_repository.dart';

import 'widgets.dart';

class Esp32Button extends HookConsumerWidget {
  const Esp32Button({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(esp32ControllerProvider).isConnected;
    return ElevatedButton(
      child: const Text('connect'),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        onPrimary: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () async {
        if (await ref.watch(isConnectedProvider.future)) {
          ref.read(esp32ControllerProvider.notifier).disconnectEsp32();
        } else {
          ref.read(esp32ControllerProvider.notifier).getEsp32Data();
        }
      },
    );
  }
}

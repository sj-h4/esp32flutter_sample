import 'widgets.dart';

class Esp32Status extends HookConsumerWidget {
  const Esp32Status({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceStatus = ref.watch(esp32ControllerProvider).deviceStatus;
    final isPressed = ref.watch(esp32ControllerProvider).isPressed;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          '$deviceStatus',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

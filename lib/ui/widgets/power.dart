import 'widgets.dart';

class Power extends HookConsumerWidget {
  const Power({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPressed = ref.watch(esp32ControllerProvider).isPressed;
    return Text(
      'isPressed: $isPressed',
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

import 'widgets.dart';
class Rudder extends HookConsumerWidget {
  const Rudder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rudder = ref.watch(esp32ControllerProvider).rudder;
    return Text(
      'Rudder: $rudder',
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

import 'widgets.dart';
class Altitude extends HookConsumerWidget {
  const Altitude({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final altitude = ref.watch(esp32ControllerProvider).altitude;
    return Text(
      '$altitude',
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

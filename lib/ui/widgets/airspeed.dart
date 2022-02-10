import 'widgets.dart';
class Airspeed extends HookConsumerWidget {
  const Airspeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final airspeed = ref.watch(esp32ControllerProvider).airspeed;
    return Text(
      '$airspeed',
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

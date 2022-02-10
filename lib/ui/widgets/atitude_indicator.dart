import 'widgets.dart';

class AtitudeIndicator extends HookConsumerWidget {
  const AtitudeIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roll = ref.watch(esp32ControllerProvider).roll;
    final pitch = ref.watch(esp32ControllerProvider).pitch;
    return Column(
      children: [
        Text(
          'pitch: $pitch',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          'roll: $roll',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

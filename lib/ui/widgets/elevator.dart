import 'widgets.dart';

class Elevator extends HookConsumerWidget {
  const Elevator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elevator = ref.watch(esp32ControllerProvider).elevator;
    final elevatorTrim = ref.watch(esp32ControllerProvider).trim;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Elevator: $elevator',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          'Elevator Trim: $elevatorTrim',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

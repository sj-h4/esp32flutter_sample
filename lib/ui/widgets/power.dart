import 'widgets.dart';

class ButtonPressed extends HookConsumerWidget {
  const ButtonPressed(this.isPressed, {Key? key}) : super(key: key);
  final bool isPressed;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'isPressed',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            '$isPressed',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }
}

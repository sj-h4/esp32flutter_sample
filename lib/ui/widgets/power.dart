import 'widgets.dart';
class Power extends HookConsumerWidget {
  const Power({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final power = 0;  // TODO: 変える
    return Text(
      'power: $power',
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

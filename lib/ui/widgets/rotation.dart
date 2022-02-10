import 'widgets.dart';
class Rotation extends HookConsumerWidget {
  const Rotation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rotation = ref.watch(esp32ControllerProvider).rotation; // TODO: ペダルからのデータにする
    return Text(
      '$rotation',
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

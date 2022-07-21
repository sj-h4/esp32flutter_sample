import 'widgets.dart';

class Airspeed extends HookConsumerWidget {
  const Airspeed(this.airspeed, {Key? key}) : super(key: key);
  final double airspeed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Airspeed',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            '$airspeed',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }
}

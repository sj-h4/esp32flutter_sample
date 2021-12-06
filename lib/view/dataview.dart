import 'package:esp32flutter_sample/view/widgets/airspeed_widget.dart';
import 'package:flutter/material.dart';

class DataView extends StatelessWidget {
  const DataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AirspeedWidget(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_water_intake/bars/bar_graph.dart';
import 'package:flutter_water_intake/data/water_data.dart';
import 'package:provider/provider.dart';

class WaterSummary extends StatelessWidget {
  final DateTime startofWeek;
  const WaterSummary({super.key, required this.startofWeek});

  @override
  Widget build(BuildContext context) {
    return Consumer<WaterData>(
        builder: (context, value, child) => SizedBox(
              height: 200,
              child: BarGraph(
                  maxY: 70,
                  sunWaterAmt: 19,
                  monWaterAmt: 34,
                  tueWaterAmt: 22,
                  wedWaterAmt: 50,
                  thuWaterAmt: 44,
                  friWaterAmt: 12,
                  satWaterAmt: 23),
            ));
  }
}

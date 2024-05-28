import 'package:flutter/material.dart';
import 'package:flutter_water_intake/bars/bar_graph.dart';
import 'package:flutter_water_intake/data/water_data.dart';
import 'package:flutter_water_intake/utils/date_helper.dart';
import 'package:provider/provider.dart';

class WaterSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const WaterSummary({super.key, required this.startOfWeek});

  @override
  Widget build(BuildContext context) {
    String sunday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String monday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String tuesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String wednesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String thursday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String friday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String saturday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));

    return Consumer<WaterData>(
        builder: (context, value, child) => SizedBox(
              height: 200,
              child: BarGraph(
                maxY: 70,
                sunWaterAmt: value.calculateDailyWaterSummary()[sunday] ?? 0,
                monWaterAmt: value.calculateDailyWaterSummary()[monday] ?? 0,
                tueWaterAmt: value.calculateDailyWaterSummary()[tuesday] ?? 0,
                wedWaterAmt: value.calculateDailyWaterSummary()[wednesday] ?? 0,
                thuWaterAmt: value.calculateDailyWaterSummary()[thursday] ?? 0,
                friWaterAmt: value.calculateDailyWaterSummary()[friday] ?? 0,
                satWaterAmt: value.calculateDailyWaterSummary()[saturday] ?? 0,
              ),
            ));
  }
}

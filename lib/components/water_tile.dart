import 'package:flutter/material.dart';
import 'package:flutter_water_intake/models/water_model.dart';

class WaterTile extends StatelessWidget {
  const WaterTile({
    super.key,
    required this.waterModel,
  });

  final WaterModel waterModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(waterModel.amount.toString()),
        subtitle: Text(waterModel.id!),
      ),
    );
  }
}

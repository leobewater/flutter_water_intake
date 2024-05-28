import 'package:flutter/material.dart';
import 'package:flutter_water_intake/data/water_data.dart';
import 'package:flutter_water_intake/models/water_model.dart';
import 'package:provider/provider.dart';

class WaterTile extends StatelessWidget {
  const WaterTile({
    super.key,
    required this.waterModel,
  });

  final WaterModel waterModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Row(
          children: [
            const Icon(Icons.water_drop, size: 20, color: Colors.blue),
            Text('${waterModel.amount.toStringAsFixed(2)} ml',
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        subtitle:
            Text('${waterModel.dateTime.month}/${waterModel.dateTime.day}'),
        trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<WaterData>(context, listen: false).delete(waterModel);
            }),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_water_intake/models/water_model.dart';
import 'package:http/http.dart' as http;

// provider
class WaterData extends ChangeNotifier {
  List<WaterModel> waterDataList = [];

  // add water
  void addWater(WaterModel water) async {
    // saving to firebase realtime db
    final url = Uri.https(
        'flutter-water-intake-default-rtdb.firebaseio.com', 'water.json');

    var response = await http.post(url,
        headers: {'Context-Type': 'application/json'},
        body: jsonEncode({
          'amount': double.parse(water.amount.toString()),
          'unit': 'ml',
          'dateTime': DateTime.now().toString(),
        }));

    // if (response.statusCode == 200) {
    //   debugPrint('Data saved');
    // } else {
    //   debugPrint('Data not saved');
    // }

    notifyListeners();
  }
}

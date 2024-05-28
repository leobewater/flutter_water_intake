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

    if (response.statusCode == 200) {
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;

      waterDataList.add(WaterModel(
          // get the id
          id: extractedData['name'],
          amount: water.amount,
          dateTime: water.dateTime,
          unit: water.unit));
    } else {
      debugPrint('Error: ${response.statusCode}');
    }

    notifyListeners();
  }

  Future<List<WaterModel>> getWater() async {
    final url = Uri.https(
        'flutter-water-intake-default-rtdb.firebaseio.com', 'water.json');

    final response = await http.get(url);

    if (response.statusCode == 200 && response.body != 'null') {
      waterDataList.clear();

      // create water data list
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;

      // map each item
      for (var element in extractedData.entries) {
        waterDataList.add(WaterModel(
            id: element.key,
            amount: element.value['amount'],
            dateTime: DateTime.parse(element.value['dateTime']),
            unit: element.value['unit']));
      }
    }

    notifyListeners();

    return waterDataList;
  }

  String getWeekday(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tues';
      case 3:
        return 'Wed';
      case 4:
        return 'Thur';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  DateTime getStartOfWeek() {
    DateTime? startOfWeek;

    // get the current date
    DateTime dateTime = DateTime.now();

    for (int i = 0; i < 7; i++) {
      // find the actual date of the week
      if (getWeekday(dateTime.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = dateTime.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }

  void delete(WaterModel waterModel) {
    final url = Uri.https('flutter-water-intake-default-rtdb.firebaseio.com',
        'water/${waterModel.id}.json');

    http.delete(url);

    // remove item from our list
    waterDataList.removeWhere((element) => element.id == waterModel.id!);

    notifyListeners();
  }
}

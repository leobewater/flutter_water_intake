class WaterModel {
  final String? id;
  final double amount;
  final DateTime dateTime;
  final String unit;

  WaterModel(
      {this.id,
      required this.amount,
      required this.dateTime,
      required this.unit});

  // getting data from database and parse to WaterModel
  factory WaterModel.fromJson(Map<String, dynamic> json, String id) {
    return WaterModel(
      id: id,
      amount: json['amount'],
      dateTime: DateTime.parse(json['dateTime']),
      unit: json['unit'],
    );
  }

  // convert water model to json for sending data to firebase
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'dateTime': DateTime.now(),
      'unit': 'ml',
    };
  }
}

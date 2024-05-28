import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final amountController = TextEditingController();

  void saveWater(String amount) async {
    // saving to firebase realtime db
    final url = Uri.https(
        'flutter-water-intake-default-rtdb.firebaseio.com',
        'water.json');

    var response = await http.post(url,
        headers: {'Context-Type': 'application/json'},
        body: jsonEncode({
          'amount': double.parse(amount),
          'unit': 'ml',
          'dateTime': DateTime.now().toString(),
        }));

    if (response.statusCode == 200) {
      debugPrint('Data saved');
    } else {
      debugPrint('Data not saved');
    }
  }

  void addWater() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add Water'),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Add water to your daily intake'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Amount'),
                  )
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      // save data to db
                      saveWater(amountController.text);
                    },
                    child: const Text('Save'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.map)),
        ],
        title: const Text('Water'),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
          onPressed: addWater, child: const Icon(Icons.add)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_water_intake/components/water_intake_summary.dart';
import 'package:flutter_water_intake/components/water_tile.dart';
import 'package:flutter_water_intake/data/water_data.dart';
import 'package:flutter_water_intake/models/water_model.dart';
import 'package:flutter_water_intake/pages/about.dart';
import 'package:flutter_water_intake/pages/settings.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final amountController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    // get all the water when this is initialized
    await Provider.of<WaterData>(context, listen: false)
        .getWater()
        .then((waters) => {
              if (waters.isNotEmpty)
                {
                  setState(() {
                    _isLoading = false;
                  })
                }
              else
                {
                  setState(() {
                    _isLoading = true;
                  })
                }
            });
  }

  void saveWater() async {
    Provider.of<WaterData>(context, listen: false).addWater(WaterModel(
        amount: double.parse(amountController.text.toString()),
        dateTime: DateTime.now(),
        unit: 'ml'));

    // if the widget is not mounted, don't do anything
    if (!context.mounted) {
      return;
    }

    clearWater();
  }

  void clearWater() {
    // clear form textfield previous value
    amountController.clear();
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
                      saveWater();

                      // close dialog box
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WaterData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          //elevation: 4,
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.map)),
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Weekly: ', style: Theme.of(context).textTheme.titleMedium),
              Text('${value.calculateWeeklyWaterIntake(value)} ml',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        body: ListView(children: [
          // graph here
          WaterSummary(startOfWeek: value.getStartOfWeek()),
          !_isLoading
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.waterDataList.length,
                  itemBuilder: (context, index) {
                    final WaterModel waterModel = value.waterDataList[index];
                    return WaterTile(waterModel: waterModel);
                  })
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ]),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Text('Water Intake',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25)),
              ),
              ListTile(
                title: const Text('Settings'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsScreen()));
                },
              ),
              ListTile(
                title: const Text('About'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutScreen()));
                },
              )
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        floatingActionButton: FloatingActionButton(
            onPressed: addWater, child: const Icon(Icons.add)),
      ),
    );
  }
}

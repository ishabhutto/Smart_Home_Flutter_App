import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SolarPanelScreen extends StatefulWidget {
  const SolarPanelScreen({Key? key}) : super(key: key);

  @override
  _SolarPanelScreenState createState() => _SolarPanelScreenState();
}

class _SolarPanelScreenState extends State<SolarPanelScreen> {
  final TextEditingController panelNameController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController installationCostController =
      TextEditingController();
  final TextEditingController monthlySavingsController =
      TextEditingController();

  Future<void> addSolarPanel() async {
    if (panelNameController.text.isNotEmpty &&
        capacityController.text.isNotEmpty &&
        installationCostController.text.isNotEmpty &&
        monthlySavingsController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('solar_panels').add({
          'name': panelNameController.text,
          'capacity': double.parse(capacityController.text),
          'installationCost': double.parse(installationCostController.text),
          'monthlySavings': double.parse(monthlySavingsController.text),
        });

        // Clear the text fields after adding
        panelNameController.clear();
        capacityController.clear();
        installationCostController.clear();
        monthlySavingsController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Solar panel added successfully!')),
        );
      } catch (e) {
        print("Error adding solar panel: $e");
      }
    } else {
      print("Please fill in all fields.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Solar Panel'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: panelNameController,
                decoration: const InputDecoration(
                    labelText: 'Panel Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: capacityController,
                decoration: const InputDecoration(
                    labelText: 'Capacity (kW)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: installationCostController,
                decoration: const InputDecoration(
                    labelText: 'Installation Cost (\$)',
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: monthlySavingsController,
                decoration: const InputDecoration(
                    labelText: 'Monthly Savings (\$)',
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: addSolarPanel,
                child: const Text('Add Solar Panel'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

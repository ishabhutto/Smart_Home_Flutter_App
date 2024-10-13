import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smarthome/home/charts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SummaryCard extends StatefulWidget {
  @override
  _SummaryCardState createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  double totalBill = 0.0;
  double totalVoltage = 0.0;
  int totalDevices = 0;

  @override
  void initState() {
    super.initState();
    fetchSummaryData();
  }

  void fetchSummaryData() {
    FirebaseFirestore.instance
        .collection('devices')
        .snapshots()
        .listen((devicesSnapshot) {
      totalBill = 0.0;
      totalVoltage = 0.0;
      totalDevices = devicesSnapshot.docs.length;

      for (var doc in devicesSnapshot.docs) {
        totalBill += doc['electricityBill'];
        totalVoltage += doc['voltage'];
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double total = totalBill + totalVoltage;
    double billPercentage = total > 0 ? (totalBill / total) * 100 : 0;
    double voltagePercentage = total > 0 ? (totalVoltage / total) * 100 : 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChartScreen()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 11, right: 11),
        child: SizedBox(
          height: 149,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter:
                  ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Apply blur effect
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5), // Lighter background
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Energy Overview',
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 5),
                            // Display electricity percentage, bill, and voltage in green text
                            Row(
                              children: [
                                Text(
                                  '+${billPercentage.toStringAsFixed(1)}%', // Bill percentage
                                  style: TextStyle(
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                    color: Colors.green, // S
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${totalBill.toStringAsFixed(1)} kWh', // Electricity bill in kWh
                                  style: TextStyle(
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Color.fromRGBO(131, 138, 143, 1)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '${totalVoltage.toStringAsFixed(1)} V', // Voltage info
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors
                                        .green, // Same green color for voltage
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            // Display total devices
                            Row(
                              children: [
                                Text(
                                  'Total Devices: ',
                                  style: TextStyle(
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color.fromRGBO(
                                      131,
                                      138,
                                      143,
                                      1,
                                    ), // Darker grey for clarity
                                  ),
                                ),
                                Text(
                                  '$totalDevices',
                                  style: TextStyle(
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors
                                        .red, // Different color for totalDevices
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 101,
                        child: SfCircularChart(
                          series: <CircularSeries>[
                            DoughnutSeries<ChartData, String>(
                              dataSource: [
                                ChartData('Electricity', billPercentage,
                                    const Color.fromARGB(255, 63, 210, 68)),
                                ChartData('Voltage', voltagePercentage,
                                    Color.fromARGB(255, 207, 244, 73)),
                                ChartData('Devices', totalDevices.toDouble(),
                                    const Color.fromARGB(255, 218, 92, 92)),
                              ],
                              xValueMapper: (ChartData data, _) =>
                                  data.category,
                              yValueMapper: (ChartData data, _) => data.value,
                              pointColorMapper: (ChartData data, _) =>
                                  data.color,
                              dataLabelMapper: (ChartData data, _) =>
                                  '${data.value.toStringAsFixed(0)}%',
                              enableTooltip: true,
                              dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                textStyle: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.category, this.value, [Color? color]) {
    if (color != null) {
      this.color = color;
    }
  }

  final String category;
  final double value;
  Color color = Colors.transparent;
}

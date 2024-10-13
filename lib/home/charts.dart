import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smarthome/core/fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  List<ChartData> totalBillData = [];
  List<ChartData> totalVoltageData = [];
  List<ChartData> deviceConsumptionData = [];
  List<LineChartData> lineChartData = [];
  int totalDevices = 0; // Variable to store the total number of devices

  @override
  void initState() {
    super.initState();
    fetchChartData();
  }

  Future<void> fetchChartData() async {
    final devicesSnapshot =
        await FirebaseFirestore.instance.collection('devices').get();

    double totalVoltage = 0;
    double totalBill = 0;
    totalDevices = devicesSnapshot.size; // Get the total number of devices

    // Collecting data for the total consumption and bills
    for (var doc in devicesSnapshot.docs) {
      double voltage = doc['voltage'];
      double bill = doc['electricityBill'];
      String deviceName = doc['name'];

      totalVoltage += voltage;
      totalBill += bill;

      // Prepare data for device consumption chart
      deviceConsumptionData.add(ChartData(deviceName, voltage));
    }

    // Prepare data for line chart (mock data for progress over time)
    lineChartData = [
      LineChartData(DateTime.now().subtract(Duration(days: 6)), 50),
      LineChartData(DateTime.now().subtract(Duration(days: 5)), 70),
      LineChartData(DateTime.now().subtract(Duration(days: 4)), 30),
      LineChartData(DateTime.now().subtract(Duration(days: 3)), 90),
      LineChartData(DateTime.now().subtract(Duration(days: 2)), 60),
      LineChartData(DateTime.now().subtract(Duration(days: 1)), 80),
      LineChartData(DateTime.now(), totalBill),
    ];

    setState(() {
      totalVoltageData = [ChartData('Total Voltage', totalVoltage)];
      totalBillData = [ChartData('Total Electricity Bill', totalBill)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Energy Consumption',
          style: AppFonts.notoSansBold.copyWith(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Total Electricity Bill Display
              Text(
                'Total Electricity Bill: \$${totalBillData.isNotEmpty ? totalBillData[0].value.toStringAsFixed(2) : '0.00'}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Total Voltage Display
              Text(
                'Total Voltage: ${totalVoltageData.isNotEmpty ? totalVoltageData[0].value.toString() : '0.00'} V',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Total Devices Display
              Text(
                'Total Devices: $totalDevices',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Pie Chart for Total Usage
              Text('Total Usage'),
              const SizedBox(height: 10),
              SfCircularChart(
                legend: Legend(isVisible: true),
                series: <CircularSeries>[
                  PieSeries<ChartData, String>(
                    dataSource: [
                      ...totalVoltageData,
                      ...totalBillData,
                      ChartData('Total Devices',
                          totalDevices.toDouble()), // Add total devices
                    ],
                    xValueMapper: (ChartData data, _) => data.category,
                    yValueMapper: (ChartData data, _) => data.value,
                    dataLabelMapper: (ChartData data, _) => '\$${data.value}',
                    enableTooltip: true,
                    // Specify bright colors for pie chart segments
                    pointColorMapper: (ChartData data, _) {
                      switch (data.category) {
                        case 'Total Voltage':
                          return Colors.redAccent;
                        case 'Total Electricity Bill':
                          return const Color.fromARGB(255, 27, 72, 50);
                        case 'Total Devices':
                          return Colors.blueAccent;
                        default:
                          return Colors.orangeAccent; // Default color
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Line Chart for Electricity Bill Progress Over Time
              Text('Electricity Bill Progress Over Time'),
              const SizedBox(height: 10),
              SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                title: ChartTitle(text: 'Electricity Bill Over the Last Week'),
                series: <LineSeries<LineChartData, DateTime>>[
                  LineSeries<LineChartData, DateTime>(
                    dataSource: lineChartData,
                    xValueMapper: (LineChartData data, _) => data.date,
                    yValueMapper: (LineChartData data, _) => data.value,
                    // Specify bright color for the line chart
                    color: Colors.purpleAccent,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Bar Chart for Device Consumption
              Text('Light Consumption by Device'),
              const SizedBox(height: 10),
              SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: 'Voltage Consumption per Device'),
                series: <BarSeries<ChartData, String>>[
                  BarSeries<ChartData, String>(
                    dataSource: deviceConsumptionData,
                    xValueMapper: (ChartData data, _) => data.category,
                    yValueMapper: (ChartData data, _) => data.value,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                    // Specify bright colors for each bar
                    color: const Color.fromARGB(255, 255, 98, 0),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Bar Chart for Total Devices, Total Voltage, and Total Bill
              Text('Total Devices, Voltage, and Bill'),
              const SizedBox(height: 10),
              SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title:
                    ChartTitle(text: 'Overview of Devices, Voltage, and Bill'),
                series: <BarSeries<ChartData, String>>[
                  BarSeries<ChartData, String>(
                    dataSource: [
                      ChartData('Total Devices', totalDevices.toDouble()),
                      ChartData(
                          'Total Voltage',
                          totalVoltageData.isNotEmpty
                              ? totalVoltageData[0].value
                              : 0.0),
                      ChartData(
                          'Total Bill',
                          totalBillData.isNotEmpty
                              ? totalBillData[0].value
                              : 0.0),
                    ],
                    xValueMapper: (ChartData data, _) => data.category,
                    yValueMapper: (ChartData data, _) => data.value,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                    // Specify bright colors for the total overview bar chart
                    color: const Color.fromARGB(255, 255, 100, 165),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.category, this.value);

  final String category;
  final double value;
}

class LineChartData {
  LineChartData(this.date, this.value);

  final DateTime date;
  final double value;
}

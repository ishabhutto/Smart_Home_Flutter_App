import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smarthome/core/fonts.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController voltageController = TextEditingController();
  final TextEditingController billController = TextEditingController();

  bool isOn = false;
  File? _image;
  double totalVoltage = 0;
  double totalElectricityBill = 0;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    calculateTotalVoltage();
  }

  void initializeNotifications() {
    const androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void calculateTotalVoltage() {
    FirebaseFirestore.instance
        .collection('devices')
        .snapshots()
        .listen((snapshot) {
      double voltageSum = 0;
      double billSum = 0;
      for (var doc in snapshot.docs) {
        voltageSum += doc['voltage'];
        billSum += doc['electricityBill'];
      }

      setState(() {
        totalVoltage = voltageSum;
        totalElectricityBill = billSum;
      });

      if (totalVoltage > 1000) {
        scheduleVoltageNotification();
      }
    });
  }

  void scheduleVoltageNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'voltage_channel_id',
      'Voltage Alerts',
      importance: Importance.max,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Voltage Alert',
      'Total voltage exceeds 1000 volts!',
      notificationDetails,
    );
  }

  Future<void> selectImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> uploadImageAndAddDevice() async {
    if (_image != null &&
        nameController.text.isNotEmpty &&
        voltageController.text.isNotEmpty &&
        billController.text.isNotEmpty) {
      try {
        String filePath = 'device_images/${nameController.text}.png';
        await FirebaseStorage.instance.ref(filePath).putFile(_image!);
        String downloadUrl =
            await FirebaseStorage.instance.ref(filePath).getDownloadURL();

        await FirebaseFirestore.instance.collection('devices').add({
          'name': nameController.text,
          'status': isOn,
          'voltage': double.parse(voltageController.text),
          'imageUrl': downloadUrl,
          'electricityBill': double.parse(billController.text),
        });

        Navigator.pop(context);
      } catch (e) {
        print("Error uploading image or adding device: $e");
      }
    } else {
      print("Please fill in all fields and select an image.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
      appBar: AppBar(
        title: Text(
          'Add New Device',
          style: AppFonts.notoSansBold.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Device Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    borderSide:
                        const BorderSide(color: Colors.black), // Black border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.black), // Black border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ), // Black border with wider stroke on focus
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: voltageController,
                decoration: InputDecoration(
                  labelText: 'Voltage (V)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    borderSide:
                        const BorderSide(color: Colors.black), // Black border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.black), // Black border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ), // Black border with wider stroke on focus
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: billController,
                decoration: InputDecoration(
                  labelText: 'Electricity Bill (\$)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    borderSide:
                        const BorderSide(color: Colors.black), // Black border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.black), // Black border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ), // Black border with wider stroke on focus
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Status: '),
                  Switch(
                    value: isOn,
                    onChanged: (val) {
                      setState(() {
                        isOn = val;
                      });
                    },
                    activeColor: Colors.black,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: selectImage,
                child: const Text('Select Image from Device'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_image != null) Image.file(_image!, height: 100),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: uploadImageAndAddDevice,
                child: const Text('Add Device'),
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

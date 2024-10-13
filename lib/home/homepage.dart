import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smarthome/home/add_Device.dart';
import 'package:smarthome/home/deviceCard.dart';
import 'package:smarthome/home/summarycard.dart';
import 'package:smarthome/profile/profile_Screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SmartHomeScreen extends StatefulWidget {
  final String username;

  const SmartHomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  _SmartHomeScreenState createState() => _SmartHomeScreenState();
}

class _SmartHomeScreenState extends State<SmartHomeScreen> {
  final CollectionReference devicesCollection =
      FirebaseFirestore.instance.collection('devices');

  // Initialize local notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // Your app icon

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String deviceName, bool status) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your_channel_id', 'your_channel_name',
            channelDescription: 'Channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0,
        'Device Status Changed',
        '$deviceName is now ${status ? "ON" : "OFF"}',
        platformChannelSpecifics);
  }

  final User? user = FirebaseAuth.instance.currentUser; // Get the current user

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
        title: Row(
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color.fromRGBO(46, 46, 46, 1),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : const AssetImage('assets/images/placeholder.jpg')
                          as ImageProvider, // Placeholder if no profile image
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Hi, ${widget.username}',
              style: const TextStyle(
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.black),
            ),
          ],
        ),
      ),
      drawer: ProfileDrawer(),
      body: Column(
        children: [
          const TabBarSection(),
          const SizedBox(height: 10),
          SummaryCard(), // Add the SummaryCard here
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: devicesCollection.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No devices added yet'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(12), // Increased padding
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75, // Adjusted aspect ratio
                    crossAxisSpacing: 12, // Increased spacing
                    mainAxisSpacing: 12, // Increased spacing
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var device = snapshot.data!.docs[index];
                    return DeviceCard(
                      deviceName: device['name'],
                      isOn: device['status'],
                      imageUrl: device['imageUrl'],
                      documentId: device.id,
                      voltage: device['voltage'],
                      showNotification:
                          _showNotification, // Pass notification function
                    );
                  },
                );
              },
            ),
          ),
          const AddNewDeviceButton(),
        ],
      ),
    );
  }
}

class AddNewDeviceButton extends StatelessWidget {
  const AddNewDeviceButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0), // Increased padding
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Add New Device'),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddDeviceScreen()));
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(
              horizontal: 40, vertical: 15), // Increased vertical padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
        ),
      ),
    );
  }
}

class TabBarSection extends StatelessWidget {
  const TabBarSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: const DefaultTabController(
        length: 3,
        child: TabBar(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: [
            Tab(
              child: Text(
                'Living Room',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Dining',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Kitchen',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

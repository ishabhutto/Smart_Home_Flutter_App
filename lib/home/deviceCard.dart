import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final bool isOn;
  final String imageUrl;
  final String documentId;
  final double voltage;
  final Future<void> Function(String deviceName, bool status) showNotification;

  const DeviceCard({
    Key? key,
    required this.deviceName,
    required this.isOn,
    required this.imageUrl,
    required this.documentId,
    required this.voltage,
    required this.showNotification,
  }) : super(key: key);

  Future<void> deleteDevice(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('devices')
          .doc(documentId)
          .delete();

      String filePath = 'device_images/$deviceName.png';
      await FirebaseStorage.instance.ref(filePath).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Device deleted successfully')),
      );
    } catch (e) {
      print("Error deleting device: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isOn ? Colors.black : const Color.fromRGBO(237, 237, 237, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isOn
                          ? Color.fromRGBO(46, 46, 46, 1)
                          : Color.fromRGBO(218, 218, 218, 1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isOn
                            ? Color.fromRGBO(46, 46, 46, 1)
                            : Color.fromRGBO(218, 218, 218, 1),
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: imageUrl.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(5),
                              child: Image.network(imageUrl,
                                  height: 40, width: 40, fit: BoxFit.cover),
                            )
                          : const Icon(Icons.device_hub,
                              color: Colors.white, size: 50),
                    ),
                  ),
                ),
                const SizedBox(height: 17),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    deviceName,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w600,
                      color: isOn ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    '$voltage V',
                    style: TextStyle(
                      color: isOn
                          ? const Color.fromRGBO(167, 167, 167, 1)
                          : const Color.fromRGBO(132, 132, 132, 1),
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Switch(
                      value: isOn,
                      onChanged: (val) {
                        FirebaseFirestore.instance
                            .collection('devices')
                            .doc(documentId)
                            .update({'status': val}).then((_) {
                          // Call notification method when status is changed
                          showNotification(deviceName, val);
                        });
                      },
                      activeColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, top: 10),
                      child: Text(
                        'On',
                        style: TextStyle(
                            color: isOn
                                ? Colors.white
                                : const Color.fromRGBO(125, 125, 125, 1),
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: Icon(
                Icons.delete,
                color: isOn ? Colors.white : Colors.black,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Confirm Deletion'),
                      content: const Text(
                          'Are you sure you want to delete this device?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            deleteDevice(context);
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

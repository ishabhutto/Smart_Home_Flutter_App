# Smart Home Automation System

## Project Description

The **Smart Home Automation System** is a mobile app designed to help users control and monitor their home devices remotely. The system leverages Firebase for user authentication and data storage, and real-time updates for device status. The app allows users to register, log in, add and manage devices, and track energy consumption through visual charts. The system is built to handle multiple devices and ensure optimal performance.

## Features

### Functional Requirements

1. **User Authentication**
   - Register an account and log in with credentials.
   - Secure login validation via Firebase Authentication.
   - Create and manage user profiles with email, username, password, and profile image.

2. **User Home Page**
   - After login, the user sees the message "There are no devices stored" if no devices are added.
   - The "Add Device" button allows users to input device details (name, voltage, electricity bill).
   - Device list displayed on the home page, allowing users to toggle device status (on/off).
   - Real-time notifications for status changes, updated in Firebase instantly.
   - Energy Overview Card displays current energy consumption, voltage, and pie charts for usage distribution.

3. **Energy Consumption Page**
   - Pie chart showing the distribution of electricity bills and voltage.
   - Line chart illustrating electricity bill progression over time.
   - Bar charts showing light consumption per device and overall usage for all devices combined.

### Non-Functional Requirements

- **Performance:** Respond to user inputs within 2 seconds, load data from Firebase within 5 seconds.
- **Security:** User data is securely stored using Firebase Authentication.
- **Scalability:** Supports up to 100 devices without performance issues.
- **Usability:** Intuitive user interface.
- **Availability:** 99% uptime for system availability.

---

## Technologies Used

- **Flutter**: For building the cross-platform mobile app.
- **Firebase**: For user authentication and real-time database storage.
- **Charts Flutter**: For displaying various charts like pie and bar charts for energy consumption.
- **Firebase Cloud Messaging (FCM)**: For real-time notifications when device status changes.

### Dependencies

- `firebase_core: ^3.4.0`
- `firebase_auth: ^5.2.0`
- `cloud_firestore: ^5.4.0`
- `image_picker: ^1.1.2`
- `flutter_switch: ^0.3.2`
- `firebase_storage: ^12.2.0`
- `flutter_local_notifications: ^17.2.3`
- `syncfusion_flutter_charts: ^24.2.9`
- `path_provider: ^2.1.4`

---

## Project Highlights

- **Real-time Device Control**: Toggle device status (on/off) with real-time Firebase updates.
- **Energy Monitoring**: Monitor electricity usage with pie charts, line charts, and bar charts.
- **Scalability**: Supports a large number of devices and multiple users simultaneously.
- **User Authentication**: Secure sign-up, login, and profile management using Firebase Authentication.

---

## Screenshots

### 1. Sign Up Screen & Profile Page

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/user-attachments/assets/b039275e-ba55-4c23-b2ac-093f7888312f" width="250" height="250"/>
  <img src="https://github.com/user-attachments/assets/dedc9691-14c8-433f-a0e8-c5bbd9f797d7" width="250" height="250"/>
</div>

### 2. Home Page (Initial View) & Add New Device Screen

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/user-attachments/assets/8124390a-beb5-4f55-a185-36d597d7c75f" width="250" height="250"/>
  <img src="https://github.com/user-attachments/assets/8525f5b2-c91c-4d1c-960f-49c7cb38404e" width="250" height="250"/>
</div>

### 3. Add Device Screen (Filled Form) & Device List after Adding New Device

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/user-attachments/assets/de5146b0-3cf3-40de-af32-3143d63e6456" width="250" height="250"/>
  <img src="https://github.com/user-attachments/assets/ed0a4a78-4841-418e-958c-4ab9b74f287a" width="250" height="250"/>
</div>

### 4. Login Screen & Notification when Device Status is Turned Off

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/user-attachments/assets/1515f090-f9dd-4a53-ba26-29b206a095e6" width="250" height="250"/>
  <img src="https://github.com/user-attachments/assets/8bb3b072-ab96-422e-91ab-26ffcbe8eb7c" width="250" height="250"/>
</div>

### 5. Notification when Device Status is Turned On & Energy Consumption Pie Chart (Device Overview)

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/user-attachments/assets/5fbdf0b4-8692-457f-a6af-64ccbf44b298" width="250" height="250"/>
  <img src="https://github.com/user-attachments/assets/fdcac56e-a9ff-44f3-999e-a8bed8928619" width="250" height="250"/>
</div>

### 6. Energy Consumption Pie Chart (Usage Distribution) & Voltage Alert Notification

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/user-attachments/assets/7145488b-c557-46d8-a6ab-a6c39359ec91" width="250" height="250"/>
  <img src="https://github.com/user-attachments/assets/dfae7016-35f1-442e-a435-bc226d341ebb" width="250" height="250"/>
</div>

### 7. Device Deletion Confirmation & Energy Consumption Line Chart

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/user-attachments/assets/cd474e81-9b0a-4229-97c6-dcbb63905803" width="250" height="250"/>
  <img src="https://github.com/user-attachments/assets/cbce3541-706d-4eaa-b1eb-6375dcede1e3" width="250" height="250"/>
</div>

### 8. Energy Consumption Bar Chart (Per Device)

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/user-attachments/assets/4ab82e6c-f65b-4be5-83c6-52b08890c09f" width="250" height="250"/>
</div>

---

## Future Enhancements

- Implement voice control for devices.
- Add support for multiple device types (e.g., lights, thermostats).
- Introduce advanced energy analytics and AI-based recommendations for energy saving.
- Improve UI with dark mode support.


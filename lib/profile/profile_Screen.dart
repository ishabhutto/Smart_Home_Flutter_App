import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/login/loginScreen.dart';

class ProfileDrawer extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser; // Get the current user

  ProfileDrawer({super.key});

  // Sign-out method
  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250, // Reduced width for the drawer
      backgroundColor: Color.fromRGBO(249, 249, 249, 1),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          const SizedBox(height: 40),
          // Profile Picture and Username
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : const AssetImage('assets/placeholder.png')
                          as ImageProvider, // Placeholder if no profile image
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Column(
              children: [
                Text(
                  user?.displayName ?? 'Smart User', // Display username
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Smart User', // Static subtitle or role
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w200,
                      fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Menu Options
          ListTile(
            leading: const Icon(
              Icons.lock,
              color: Colors.black,
            ),
            title: const Text('Privacy',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    fontSize: 16)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.favorite,
              color: Colors.black,
            ),
            title: const Text('Favourites',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    fontSize: 16)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.help,
              color: Colors.black,
            ),
            title: const Text('Help Center',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    fontSize: 16)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.card_giftcard,
              color: Colors.black,
            ),
            title: const Text('Invite a friend',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    fontSize: 16)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            title: const Text('Sign Out',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    fontSize: 16)),
            onTap: () => _signOut(context), // Call sign-out function
          ),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smarthome/core/colors.dart';
import 'package:smarthome/core/fonts.dart';
import 'package:smarthome/login/loginScreen.dart';
import 'package:smarthome/services/authService.dart';
import 'package:smarthome/widgets/customRoundedButton.dart';
import 'package:smarthome/widgets/customTextField.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();
  String _errorMessage = '';
  File? _profileImage;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _passwordsMatch = true;
  bool _isValidEmail = true;
  bool _isValidPassword = true;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadProfileImage(String userId) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$userId.jpg');

      await ref.putFile(_profileImage!);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  bool _validateEmail(String email) {
    return email.contains('@');
  }

  bool _validatePassword(String password) {
    final hasSpecialCharacter = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    return password.length >= 6 && hasSpecialCharacter.hasMatch(password);
  }

  Future<void> _signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String username = _usernameController.text.trim();

    setState(() {
      _isValidEmail = _validateEmail(email);
      _isValidPassword = _validatePassword(password);
      _passwordsMatch = password == confirmPassword;
    });

    if (!_isValidEmail || !_isValidPassword || !_passwordsMatch) {
      return; // Exit if any validation fails
    }

    try {
      User? user = await _authService.signUp(email, password, username);
      if (user != null && _profileImage != null) {
        String? downloadUrl = await _uploadProfileImage(user.uid);

        if (downloadUrl != null) {
          await user.updatePhotoURL(downloadUrl);
          await user.updateDisplayName(username);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(username: username),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Sign-up failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        title: Text(
          'Sign Up',
          style: AppFonts.notoSansBold.copyWith(fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        radius: 47,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : const AssetImage('assets/images/placeholder.jpg')
                                as ImageProvider,
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    if (_profileImage == null)
                      const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 30,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Upload a picture',
                style: AppFonts.lexendMedium,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _usernameController,
                labelText: 'Username',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                errorText: _isValidEmail ? null : 'Enter a valid email.',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: !_passwordVisible,
                errorText: _isValidPassword
                    ? null
                    : 'Password must be 6+ characters & contain a special character.',
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _confirmPasswordController,
                labelText: 'Confirm Password',
                obscureText: !_confirmPasswordVisible,
                errorText: _passwordsMatch ? null : 'Passwords do not match.',
                suffixIcon: IconButton(
                  icon: Icon(
                    _confirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _confirmPasswordVisible = !_confirmPasswordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              CustomRoundedButton(
                label: 'Sign Up',
                onPressed: _signUp,
              ),
              const SizedBox(height: 20),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

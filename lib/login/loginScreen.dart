import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/core/colors.dart';
import 'package:smarthome/core/fonts.dart';
import 'package:smarthome/home/homepage.dart';
import 'package:smarthome/services/authService.dart';
import 'package:smarthome/signup/signup.dart';
import 'package:smarthome/widgets/customRoundedButton.dart';
import 'package:smarthome/widgets/customTextField.dart';
import 'package:smarthome/widgets/snackbar.dart';

class LoginPage extends StatefulWidget {
  final String? username;

  const LoginPage({super.key, this.username});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  String _errorMessage = '';
  bool _isPasswordVisible = false;
  bool _isValidEmail = true;
  bool _isValidPassword = true;

  bool _validateEmail(String email) {
    // Check if email contains '@' and has a basic structure
    return email.contains('@') && email.contains('.');
  }

  bool _validatePassword(String password) {
    // Password must be greater than 6 characters and contain at least one special character
    final specialCharacterRegex = RegExp(r'^(?=.*?[!@#\$&*~])');
    return password.length > 6 && specialCharacterRegex.hasMatch(password);
  }

  Future<void> _logIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    setState(() {
      _isValidEmail = _validateEmail(email);
      _isValidPassword = _validatePassword(password);
    });

    if (!_isValidEmail || !_isValidPassword) {
      return; // Don't proceed if validation fails
    }

    Map<String, dynamic>? userData = await _authService.logIn(email, password);
    if (userData != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SmartHomeScreen(
            username: userData['username'] ?? '',
          ),
        ),
      );
      showCustomSnackbar(context, 'Login successful!',
          backgroundColor: Colors.green);
    } else {
      showCustomSnackbar(context, 'Login failed. Create an account to login.',
          backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Login',
          style: AppFonts.notoSansBold.copyWith(fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/login.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),

              // Display welcome message if username is available
              if (widget.username != null)
                Text(
                  'Welcome, ${widget.username}!',
                  style: AppFonts.notoSansBold
                      .copyWith(fontSize: 15, color: AppColors.black),
                ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                errorText: _isValidEmail ? null : 'Enter a valid email.',
              ),
              const SizedBox(height: 10),

              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: !_isPasswordVisible,
                errorText: _isValidPassword
                    ? null
                    : 'Password must be > 6 chars with 1 special character.',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              CustomRoundedButton(
                label: 'Login',
                onPressed: _logIn,
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                child: Text(
                  "Don't have an account? Sign Up",
                  style: AppFonts.lexendMedium
                      .copyWith(fontSize: 14, color: AppColors.black),
                ),
              ),

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

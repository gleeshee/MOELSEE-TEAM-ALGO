import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moelsee_final/reusable_widget/reusable.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // Required for utf8.encode

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isRememberMeChecked = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to check user credentials
  Future<void> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields.')),
      );
      return;
    }

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('user')
          .where('Email', isEqualTo: emailController.text)
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password.')),
        );
        return;
      }

      final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;

      if (userData['Password'] == hashPassword(passwordController.text)) {
        // Save user data to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userEmail', userData['Email']);
        await prefs.setString('userFullName', userData['Full Name'] ?? '');
        await prefs.setString('userPhone', userData['Phone'] ?? '');

        // Save additional session data if "Remember Me" is checked
        if (isRememberMeChecked) {
          await saveUserSession(
            email: userData['Email'],
            fullName: userData['Full Name'] ?? '',
            phone: userData['Phone'] ?? '',
          );
        }

        Navigator.pushReplacementNamed(context, '/profile');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Method to hash the password
  String hashPassword(String password) {
    final bytes = utf8.encode(password); // Convert password to bytes
    return sha256.convert(bytes).toString(); // Generate hash
  }

  // Save user session locally using SharedPreferences
  Future<void> saveUserSession({
    required String email,
    required String fullName,
    required String phone,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', email);
    await prefs.setString('userFullName', fullName);
    await prefs.setString('userPhone', phone);
  }

  // Load user session
  Future<void> loadUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Navigate to homepage if user is already logged in
      Navigator.pushNamed(context, '/reports');
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserSession(); // Check if user is already logged in
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const SizedBox(height: 20),
            Image.asset(
              'assets/logo.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 20),
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Sign in to access your account',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 30),
            myTextField(
              controller: emailController,
              hintText: 'Enter your email',
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 20),
            myTextField(
              controller: passwordController,
              hintText: 'Password',
              icon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 10),
            Container(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isRememberMeChecked,
                        onChanged: (value) {
                          setState(() {
                            isRememberMeChecked = value!;
                          });
                        },
                      ),
                      const Text('Remember me'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle forgot password
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            myButton(
              text: 'Login',
              onPressed: loginUser,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'New Member?',
                  style: TextStyle(color: Colors.black54),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    'Register now',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

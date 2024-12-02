import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moelsee_final/screens/history.dart';
import 'package:moelsee_final/screens/homepage.dart';
import 'package:moelsee_final/screens/loading_screen.dart';
import 'package:moelsee_final/screens/login.dart';
import 'package:moelsee_final/screens/option.dart';
import 'package:moelsee_final/screens/profile.dart';
import 'package:moelsee_final/screens/register.dart';
import 'package:moelsee_final/screens/reports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyBvkz2Xt8W7wMxoeP6fM6-cce1f6faO9E0",
              authDomain: "moelsee-98281.firebaseapp.com",
              projectId: "moelsee-98281",
              storageBucket: "moelsee-98281.firebasestorage.app",
              messagingSenderId: "778774901127",
              appId: "1:778774901127:web:87a8a8d3c4fb026f72e322",
              measurementId: "G-W3ZFMRRSGX"));
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    print('Error initializing Firebase: $e ');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/loading',
      routes: {
        '/loading': (context) => LoadingScreen(),
        '/option': (context) => OptionScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => Homepage(),
        '/reports': (context) => ReportPage(),
        '/history': (context) => BillHistory(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}

class Reportpage {}

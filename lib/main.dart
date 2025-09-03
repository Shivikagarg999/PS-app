import 'package:flutter/material.dart';
import './screens/welcomeScreen1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pretty Saheli',
      theme: ThemeData(primarySwatch: Colors.pink, useMaterial3: true),
      home: const WelcomeScreen1(), // Changed to WelcomeScreen1
      debugShowCheckedModeBanner: false,
    );
  }
}

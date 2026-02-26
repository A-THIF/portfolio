import 'package:flutter/material.dart';
import 'screens/loading_screen_opening.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Athif Gamified Portfolio',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const LoadingScreenOpening(),
    );
  }
}

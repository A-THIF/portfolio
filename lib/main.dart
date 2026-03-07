import 'package:flutter/material.dart';
import 'package:portfolio/screens/mobile_info_screen.dart';
import 'screens/app_start_wrapper.dart';
import 'routes/app_routes.dart';
import 'screens/game_screen.dart';

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
      home: const AppStartWrapper(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

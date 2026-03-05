import 'package:flutter/material.dart';
import 'screens/app_start_wrapper.dart';
import 'routes/app_routes.dart';
import 'package:flutter_web_plugins/url_strategy.dart'; // Add this import

void main() {
  usePathUrlStrategy(); // This removes the '#' from your URLs
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
      initialRoute: AppRoutes.lock,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

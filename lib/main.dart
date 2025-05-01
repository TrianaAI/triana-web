import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:triana_web/routes/routes.dart';

void main() {
  runApp(ModularApp(module: MainRoutes(), child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/front_counter');
    // Modular.setInitialRoute('/home');
    return MaterialApp.router(
      title: 'Triana',
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

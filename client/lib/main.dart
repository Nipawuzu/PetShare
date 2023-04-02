import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pet_share/app_gate.dart';
import 'package:pet_share/environment.dart';
import 'package:pet_share/theme.dart';

Future main() async {
  await dotenv.load(fileName: Environment.filename);
  HttpOverrides.global = PetShareHttpOverrides();
  runApp(const PetShare());
}

class PetShare extends StatelessWidget {
  const PetShare({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const Scaffold(
        body: SafeArea(child: AppMainGate()),
      ),
    );
  }
}

class PetShareHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

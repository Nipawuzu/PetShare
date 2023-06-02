import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pet_share/app_gate.dart';
import 'package:pet_share/environment.dart';

Future main() async {
  await appSetup();
  runApp(const PetShare());
}

Future appSetup() async {
  await dotenv.load(fileName: Environment.filename);
  HttpOverrides.global = PetShareHttpOverrides();
}

class PetShare extends StatelessWidget {
  const PetShare({super.key});
  @override
  Widget build(BuildContext context) {
    return const AppMainGate();
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

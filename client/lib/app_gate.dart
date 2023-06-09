import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/services/announcements/service.dart';
import 'package:pet_share/environment.dart';
import 'package:pet_share/login_register/gate.dart';
import 'package:pet_share/services/auth/service.dart';
import 'package:pet_share/services/shelter/service.dart';
import 'package:pet_share/theme.dart';
import 'package:provider/provider.dart';

class AppMainGate extends StatelessWidget {
  const AppMainGate({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) =>
              AnnouncementService(Dio(), Environment.announcementsApiUrl),
        ),
        Provider(
          create: (context) => AdopterService(Dio(), Environment.adopterApiUrl),
        ),
        Provider(
          create: (context) => ShelterService(Dio(), Environment.shelterApiUrl),
        ),
        Provider(
          create: (context) {
            return AuthService(Dio());
          },
        )
      ],
      child: MaterialApp(
        themeMode: ThemeMode.light,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: const Scaffold(
          body: SafeArea(
            child: AuthGate(),
          ),
        ),
      ),
    );
  }
}

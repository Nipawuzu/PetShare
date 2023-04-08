import 'package:flutter/material.dart';
import 'package:pet_share/announcements/service.dart';
import 'package:pet_share/applications/service.dart';
import 'package:pet_share/environment.dart';
import 'package:pet_share/login_register/gate.dart';
import 'package:provider/provider.dart';

class AppMainGate extends StatelessWidget {
  const AppMainGate({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
            create: (context) =>
                AnnouncementService(Environment.announcementsApiUrl)),
        Provider(create: (context) => ApplicationService()),
      ],
      child: const AuthGate(),
    );
  }
}

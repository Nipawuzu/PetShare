import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pet_share/announcements/service.dart';
import 'package:pet_share/applications/service.dart';
import 'package:pet_share/environment.dart';
import 'package:provider/provider.dart';

import 'package:pet_share/auth/temporary_auth_gate.dart';

class AppMainGate extends StatelessWidget {
  const AppMainGate({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
            create: (context) =>
                AnnouncementService(Dio(), Environment.announcementsApiUrl)),
        Provider(
          create: (context) => ApplicationService(),
        ),
      ],
      // child: const AllViews(),
      child: const TemporaryAuthGate(),
    );
  }
}

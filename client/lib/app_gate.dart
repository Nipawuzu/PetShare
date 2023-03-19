import 'package:flutter/material.dart';
import 'package:pet_share/all_views.dart';
import 'package:pet_share/annoucements/service.dart';
import 'package:pet_share/environment.dart';
import 'package:provider/provider.dart';

class AppMainGate extends StatelessWidget {
  const AppMainGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (context) =>
            AnnouncementService(Environment.announcementsApiUrl),
        child: const AllViews());
  }
}

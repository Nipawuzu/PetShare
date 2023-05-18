import 'package:flutter/material.dart';
import 'package:pet_share/announcements/announcement_grid/announcement_tiles_grid.dart';
import 'package:pet_share/announcements/details/view.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/services/announcements/service.dart';

class AddedAnnouncements extends StatelessWidget {
  const AddedAnnouncements(
      {super.key,
      required this.announcementService,
      required this.adopterService});

  final AnnouncementService announcementService;
  final AdopterService adopterService;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: announcementService.getAnnouncements(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AnnouncementTilesGrid(
            pageTitle: "Ogłoszenia",
            announcements: snapshot.data!,
            announcementService: announcementService,
            adopterService: adopterService,
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: TextWithBasicStyle(
                text: snapshot.error.toString(),
                align: TextAlign.center,
              ),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          ),
        );
      },
    );
  }
}

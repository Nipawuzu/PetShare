import 'package:flutter/material.dart';
import 'package:pet_share/announcements/announcement_grid/announcement_tiles_grid.dart';
import 'package:pet_share/announcements/details/view.dart';
import 'package:pet_share/common_widgets/gif_views.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/services/announcements/service.dart';

class ObservedAnnouncements extends StatelessWidget {
  const ObservedAnnouncements(
      {super.key,
      required this.announcementService,
      required this.adopterService});

  final AnnouncementService announcementService;
  final AdopterService adopterService;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: announcementService.getObservedAnnouncements(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CatProgressIndicator();
        } else if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.data == null) {
          return Scaffold(
            body: Center(
              child: TextWithBasicStyle(
                text: snapshot.error.toString(),
                align: TextAlign.center,
              ),
            ),
          );
        }

        return AnnouncementTilesGrid(
          pageTitle: "Obserwowane ogłoszenia",
          announcements: snapshot.data!.data!,
          announcementService: announcementService,
          adopterService: adopterService,
        );
      },
    );
  }
}

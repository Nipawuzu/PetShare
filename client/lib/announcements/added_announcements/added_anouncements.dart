import 'package:flutter/material.dart';
import 'package:pet_share/announcements/announcement_grid/announcement_tiles_grid.dart';
import 'package:pet_share/common_widgets/gif_views.dart';
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
        if (snapshot.hasData && snapshot.data!.data != null) {
          return AnnouncementTilesGrid(
            pageTitle: "Ogłoszenia",
            announcements: snapshot.data!.data!,
            announcementService: announcementService,
            adopterService: adopterService,
          );
        } else if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.data == null) {
          return const Scaffold(
            body: Center(
              child: RabbitErrorScreen(
                text: Text("Wystapił błąd podczas pobierania danych"),
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

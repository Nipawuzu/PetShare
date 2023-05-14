import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pet_share/announcements/added_announcements/announcement_tile.dart';
import 'package:pet_share/announcements/details/gate.dart';
import 'package:pet_share/announcements/details/view.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/services/announcements/service.dart';

class AnnouncementsGrid extends StatelessWidget {
  const AnnouncementsGrid(
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

class AnnouncementTilesGrid extends StatelessWidget {
  const AnnouncementTilesGrid({
    super.key,
    required this.announcements,
    required this.announcementService,
    required this.adopterService,
  });

  final List<Announcement> announcements;
  final AnnouncementService announcementService;
  final AdopterService adopterService;
  final int crossAxisCount = 2;

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back)),
      title: const Text('Ogłoszenia'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: MasonryGridView.count(
        key: const PageStorageKey<String>('announcements'),
        crossAxisCount: crossAxisCount,
        itemCount: announcements.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AnnouncementDetailsGate(
                announcement: announcements[index],
                adopterService: adopterService,
                announcementService: announcementService,
              ),
            ),
          ),
          child: AnnouncementTile(
            announcement: announcements[index],
            announcementService: announcementService,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pet_share/announcements/announcement_grid/announcement_tile.dart';
import 'package:pet_share/announcements/details/gate.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/services/announcements/service.dart';

class AnnouncementTilesGrid extends StatelessWidget {
  const AnnouncementTilesGrid({
    super.key,
    required this.announcements,
    required this.announcementService,
    required this.adopterService,
    required this.pageTitle,
  });

  final List<Announcement> announcements;
  final AnnouncementService announcementService;
  final AdopterService adopterService;
  final String pageTitle;
  final int crossAxisCount = 2;

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back)),
      title: Text(pageTitle),
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
          ),
        ),
      ),
    );
  }
}

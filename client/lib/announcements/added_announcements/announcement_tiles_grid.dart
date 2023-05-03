import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pet_share/announcements/added_announcements/announcement_tile.dart';
import 'package:pet_share/announcements/added_announcements/cubit.dart';
import 'package:pet_share/announcements/models/announcement.dart';

class AnnouncementTilesGrid extends StatelessWidget {
  const AnnouncementTilesGrid({
    super.key,
    required this.announcements,
  });
  final List<Announcement> announcements;

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
          onTap: () => context
              .read<GridOfAnnouncementsCubit>()
              .seeDetails(announcements[index]),
          child: AnnouncementTile(
            announcement: announcements[index],
          ),
        ),
      ),
    );
  }
}

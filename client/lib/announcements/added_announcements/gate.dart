import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/announcements/added_announcements/after_adoption_page.dart';
import 'package:pet_share/announcements/added_announcements/announcement_tiles_grid.dart';
import 'package:pet_share/announcements/added_announcements/cubit.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/announcements/details/view.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/services/announcements/service.dart';

class AnnouncementsGridGate extends StatefulWidget {
  const AnnouncementsGridGate({
    super.key,
    required this.announcementService,
    required this.adopterService,
    required this.futureAnnouncements,
  });
  final AnnouncementService announcementService;
  final AdopterService adopterService;
  final Future<List<Announcement>> futureAnnouncements;

  @override
  State<AnnouncementsGridGate> createState() => _AnnouncementsGridGateState();
}

class _AnnouncementsGridGateState extends State<AnnouncementsGridGate> {
  late List<Announcement> announcements;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.futureAnnouncements,
        builder: (((context, snapshot) {
          if (snapshot.hasData) {
            announcements = snapshot.data!;
            return BlocProvider(
              create: (_) => GridOfAnnouncementsCubit(
                  widget.announcementService, widget.adopterService),
              child: BlocBuilder<GridOfAnnouncementsCubit,
                  ListOfAnnouncementsState>(
                builder: (context, state) {
                  if (state is GridViewState) {
                    return AnnouncementTilesGrid(
                      announcements: announcements,
                    );
                  } else if (state is AnnouncementDetailsState) {
                    return AnnouncementAndPetDetails(
                        announcement: state.announcement);
                  } else if (state is AfterAdoptionState) {
                    return AfterAdoptionPage(
                      message: state.message,
                      suceed: state.success,
                    );
                  }
                  return Container();
                },
              ),
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
        })));
  }
}

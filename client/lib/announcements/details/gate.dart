import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/announcements/added_announcements/after_adoption_page.dart';
import 'package:pet_share/announcements/details/cubit.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/announcements/details/view.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/services/announcements/service.dart';

class AnnouncementDetailsGate extends StatefulWidget {
  const AnnouncementDetailsGate({
    super.key,
    required this.announcementService,
    required this.adopterService,
    required this.announcement,
  });
  final AnnouncementService announcementService;
  final AdopterService adopterService;
  final Announcement announcement;

  @override
  State<AnnouncementDetailsGate> createState() =>
      _AnnouncementDetailsGateState();
}

class _AnnouncementDetailsGateState extends State<AnnouncementDetailsGate> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnnouncementDetailsCubit(widget.announcementService,
          widget.adopterService, widget.announcement),
      child: BlocBuilder<AnnouncementDetailsCubit, AnnouncementDetailsState>(
        builder: (context, state) {
          if (state is DetailsState) {
            return AnnouncementAndPetDetails(announcement: state.announcement);
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
  }
}

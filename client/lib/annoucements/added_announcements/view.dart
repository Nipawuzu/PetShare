import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/annoucements/added_announcements/cubit.dart';
import 'package:pet_share/annoucements/announcement.dart';
import 'package:pet_share/annoucements/details/view.dart';

class AddedAnnouncements extends StatefulWidget {
  const AddedAnnouncements({super.key, required this.announcements});
  final List<Announcement> announcements;

  @override
  State<AddedAnnouncements> createState() => _AddedAnnouncementsState();
}

class _AddedAnnouncementsState extends State<AddedAnnouncements> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListOfAnnouncementsCubit(),
      child: BlocBuilder<ListOfAnnouncementsCubit, ListOfAnnouncementsState>(
        builder: (context, state) {
          if (state is ListViewState) {
            return AddedAnnouncementsList(
              announcements: widget.announcements,
            );
          } else if (state is AnnouncementDetailsState) {
            return AnnouncementAndPetDetails(announcement: state.announcement);
          }
          return Container();
        },
      ),
    );
  }
}

class AddedAnnouncementsList extends StatelessWidget {
  const AddedAnnouncementsList({super.key, required this.announcements});
  final List<Announcement> announcements;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: announcements.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => context
              .read<ListOfAnnouncementsCubit>()
              .seeDetails(announcements[index]),
          child: AnnouncementTile(
            announcement: announcements[index],
          ),
        ),
      ),
    );
  }
}

class AnnouncementTile extends StatelessWidget {
  const AnnouncementTile({super.key, required this.announcement});
  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.orange, width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                  child: Text(
                    announcement.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    announcement.description,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style:
                        const TextStyle(fontSize: 15, fontFamily: "Quicksand"),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ImageWidget(
                        size: 150,
                        image: announcement.pet.photo != null
                            ? Image.memory(announcement.pet.photo!)
                            : null,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            firstText: "Schronisko: ",
                            secondText: announcement.shelter.fullShelterName,
                            isFirstTextInBold: true,
                          ),
                          CustomTextField(
                            firstText: "Status ogłoszenia: ",
                            secondText: statusToString(announcement.status),
                            isFirstTextInBold: true,
                            secondTextColor: statusToColor(announcement.status),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String statusToString(AnnouncementStatus status) {
  switch (status) {
    case AnnouncementStatus.open:
      return "Otwarte";
    case AnnouncementStatus.closed:
      return "Zamknięte";
    case AnnouncementStatus.removed:
      return "Usunięte";
    case AnnouncementStatus.inVerification:
      return "Użytkownik w trakcie weryfikacji";
  }
}

Color statusToColor(AnnouncementStatus status) {
  switch (status) {
    case AnnouncementStatus.open:
      return Colors.green;
    case AnnouncementStatus.closed:
      return Colors.red;
    case AnnouncementStatus.removed:
      return Colors.brown;
    case AnnouncementStatus.inVerification:
      return Colors.blue;
  }
}

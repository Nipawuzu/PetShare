import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/announcements/added_announcements/added_anouncements.dart';
import 'package:pet_share/announcements/form/view.dart';
import 'package:pet_share/announcements/observed_announcements/observed_announcements_grid.dart';
import 'package:pet_share/applications/received_applications/view.dart';
import 'package:pet_share/shelter/main_screen/view.dart';

class AllViews extends StatelessWidget {
  const AllViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          ViewsListTile(
            text: "Dodaj nowe ogłoszenie",
            child: NewAnnouncementForm(context.read()),
          ),
          ViewsListTile(
            text: "Dodane ogłoszenia",
            child: AddedAnnouncements(
              announcementService: context.read(),
              adopterService: context.read(),
            ),
          ),
          ViewsListTile(
            text: "Oferty adopcji",
            child: ReceivedApplications(context.read()),
          ),
          const ViewsListTile(
            text: "Widok sheltera",
            child: ShelterMainScreen(),
          ),
          ViewsListTile(
            text: "Obserwowane\nogłoszenia",
            child: ObservedAnnouncements(
              announcementService: context.read(),
              adopterService: context.read(),
            ),
          )
        ],
      ),
    );
  }
}

class ViewsListTile extends StatelessWidget {
  const ViewsListTile({super.key, required this.child, this.text, this.image});

  final Widget child;
  final String? text;
  final ImageProvider? image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SizedBox(
        height: 120,
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => child,
            ),
          ),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    text ?? child.runtimeType.toString(),
                    style: const TextStyle(
                        fontSize: 22,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600),
                  ),
                  if (image != null)
                    const SizedBox(
                      width: 16,
                    ),
                  if (image != null)
                    LayoutBuilder(
                      builder: (context, constraints) => SizedBox(
                        width: constraints.maxHeight * 0.8,
                        child: Image(image: image!),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

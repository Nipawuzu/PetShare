import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pet_share/announcements/details/view.dart';
import 'package:pet_share/announcements/models/pet.dart';
import 'package:pet_share/applications/application.dart';
import 'package:pet_share/applications/details/view.dart';
import 'package:pet_share/common_widgets/list_header_view.dart';

class PetDetails extends StatefulWidget {
  const PetDetails({required this.pet, this.applications, super.key});

  final Pet pet;
  final List<Application>? applications;

  @override
  State<PetDetails> createState() => _PetDetailsState();
}

class _PetDetailsState extends State<PetDetails> {
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(widget.pet.name),
    );
  }

  Color _interestToColor(int applicationsCount) {
    if (applicationsCount <= 5) {
      return Colors.green.shade200;
    }

    if (applicationsCount <= 10) {
      return Colors.green.shade400;
    }

    if (applicationsCount <= 20) {
      return Colors.yellow.shade500;
    }

    if (applicationsCount <= 30) {
      return Colors.orange.shade500;
    }

    return Colors.red.shade400;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: ListHeaderView(
        toolbarScreenRatio: 1 / 3,
        header: Column(
          children: [
            if (widget.pet.photoUrl != null)
              Expanded(
                child: CachedNetworkImage(
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: widget.pet.photoUrl!,
                ),
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Liczba wniosków: "),
                      Chip(
                        labelPadding: const EdgeInsets.fromLTRB(4, -5, 4, -5),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        label: Text(widget.applications!.length.toString()),
                        backgroundColor:
                            _interestToColor(widget.applications!.length),
                      ),
                    ],
                  ),
                  ActionChip(
                    label: const Row(
                      children: [
                        Text("Ogłoszenie"),
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AnnouncementAndPetDetails(
                              announcement:
                                  widget.applications!.first.announcement),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                childCount: widget.applications!.length, (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ApplicationDetails(widget.applications![index]),
                    ),
                  );
                },
                leading: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.person)]),
                title: Text(widget.applications![index].adopter.userName),
                subtitle:
                    Text("Data: ${widget.applications![index].creationDate}"),
                trailing: const Icon(Icons.arrow_forward_ios),
              );
            }),
          )
        ],
        onRefresh: () async {
          return null;
        },
        buildWelcome: (BuildContext context) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pets, size: 64),
              SizedBox(height: 16),
              Text("Brak wniosków"),
            ],
          );
        },
        data: null,
        itemBuilder: (BuildContext context, List<dynamic> list) => SliverList(
          delegate: SliverChildBuilderDelegate(
              childCount: widget.applications!.length, (context, index) {
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ApplicationDetails(widget.applications![index]),
                  ),
                );
              },
              leading: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.person)]),
              title: Text(widget.applications![index].adopter.userName),
              subtitle:
                  Text("Data: ${widget.applications![index].creationDate}"),
              trailing: const Icon(Icons.arrow_forward_ios),
            );
          }),
        ),
      ),
    );
  }
}

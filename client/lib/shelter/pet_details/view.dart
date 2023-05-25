import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/announcements/details/view.dart';
import 'package:pet_share/announcements/models/pet.dart';
import 'package:pet_share/applications/application.dart';
import 'package:pet_share/applications/details/view.dart';
import 'package:pet_share/common_widgets/interest_to_color.dart';
import 'package:pet_share/common_widgets/list_header_view.dart';
import 'package:pet_share/services/adopter/service.dart';

import '../../services/service_response.dart';

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

  Widget _buildWelcome(
      BuildContext context, MapEntry<Pet, List<Application>> entry) {
    return Column(
      children: [
        if (entry.key.photoUrl != null)
          Expanded(
            child: CachedNetworkImage(
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              imageUrl: entry.key.photoUrl!,
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Liczba wniosków: "),
                  Chip(
                    labelPadding: const EdgeInsets.fromLTRB(4, 5, 4, 5),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    label: Text(entry.value.length.toString()),
                    backgroundColor: interestToColor(entry.value.length),
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
                          announcement: entry.value.first.announcement),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildData(
      BuildContext context, MapEntry<Pet, List<Application>> entry) {
    if (entry.value.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(child: Text("Brak wniosków")),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(childCount: entry.value.length,
          (context, index) {
        return ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ApplicationDetails(entry.value[index]),
              ),
            );
          },
          leading: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.person)]),
          title: Text(entry.value[index].adopter.userName),
          subtitle: Text("Data: ${entry.value[index].creationDate}"),
          trailing: const Icon(Icons.arrow_forward_ios),
        );
      }),
    );
  }

  Future<ServiceResponse<MapEntry<Pet, List<Application>>>>
      _getPetAndApplications(
          MapEntry<Pet, List<Application>> oldMapEntry) async {
    var res = await context.read<AdopterService>().getApplications();
    if (res.data != null) {
      var newMapEntry =
          groupBy(res.data!, (Application a) => a.announcement.pet)
                  .entries
                  .firstWhereOrNull((e) => e.key.id == widget.pet.id) ??
              MapEntry(widget.pet, []);
      setState(() {});
      return ServiceResponse(data: newMapEntry);
    }
    return ServiceResponse(data: MapEntry(widget.pet, []), error: res.error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: ListHeaderView(
        toolbarScreenRatio: 1 / 3,
        onRefresh: _getPetAndApplications,
        welcomeBuilder: _buildWelcome,
        data: ServiceResponse(
            data: MapEntry(widget.pet, widget.applications ?? [])),
        itemBuilder: _buildData,
      ),
    );
  }
}

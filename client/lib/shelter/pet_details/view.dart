import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/announcements/details/view.dart';
import 'package:pet_share/announcements/models/pet.dart';
import 'package:pet_share/applications/application.dart';
import 'package:pet_share/applications/details/view.dart';
import 'package:pet_share/common_widgets/custom_text_field.dart';
import 'package:pet_share/common_widgets/header_data_list/view.dart';
import 'package:pet_share/common_widgets/interest_to_color.dart';
import 'package:pet_share/shelter/pet_details/cubit.dart';
import 'package:pet_share/shelter/pet_details/view_model.dart';
import 'package:pet_share/utils/datetime_format.dart';

class PetDetails extends StatefulWidget {
  const PetDetails(
      {required this.pet, this.applications = const [], super.key});

  final Pet pet;
  final List<Application> applications;

  @override
  State<PetDetails> createState() => _PetDetailsState();
}

class _PetDetailsState extends State<PetDetails> {
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Colors.transparent,
      title: Text(
        widget.pet.name,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildWelcome(BuildContext context, PetDetailsViewModel viewModel) {
    return Column(
      children: [
        if (viewModel.pet.photoUrl != null)
          Expanded(
            child: CachedNetworkImage(
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              imageUrl: viewModel.pet.photoUrl!,
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
                  const SizedBox(width: 4),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: interestToColor(viewModel.numberOfApplications)),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Text(viewModel.numberOfApplications.toString())),
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
                  if (viewModel.announcement != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AnnouncementAndPetDetails(
                            announcement: viewModel.announcement!),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildData(BuildContext context, List<Application> applications) {
    if (applications.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(child: Text("Brak wniosków")),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(childCount: applications.length,
          (context, index) {
        return ListTile(
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ApplicationDetails(applications[index]),
              ),
            );

            setState(() {});
          },
          leading: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.person)]),
          title: Text(applications[index].adopter.userName),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomTextField(
                firstText: "Status: ",
                secondText: applicationStatusToString(
                    applications[index].applicationStatus),
                secondTextColor: applicationStatusToColor(
                        applications[index].applicationStatus)
                    .shade700,
                paddingSize: 0,
                textScaleFactor: 0.85,
              ),
              const Spacer(),
              Text(applications[index].creationDate.formatDay()),
              const SizedBox(width: 8.0)
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
        );
      }),
    );
  }

  Widget _buildBody(BuildContext context) {
    return HeaderDataList(
      headerToListRatio: 0.2,
      headerBuilder: _buildWelcome,
      listBuilder: _buildData,
      cubit: PetDetailsCubit(context.read(), context.read(),
          pet: widget.pet, applications: widget.applications),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }
}

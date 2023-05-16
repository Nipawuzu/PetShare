import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:collection/collection.dart";
import 'package:pet_share/announcements/form/view.dart';
import 'package:pet_share/announcements/models/pet.dart';
import 'package:pet_share/application.dart';
import 'package:pet_share/applications/received_applications/view.dart';
import 'package:pet_share/common_widgets/cat_progess_indicator.dart';
import 'package:pet_share/common_widgets/list_header_view.dart';
import 'package:pet_share/services/adopter/service.dart';

class ShelterMainScreen extends StatefulWidget {
  const ShelterMainScreen({super.key});

  @override
  State<ShelterMainScreen> createState() => _ShelterMainScreenState();
}

class _ShelterMainScreenState extends State<ShelterMainScreen>
    with TickerProviderStateMixin {
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {},
      ),
      centerTitle: true,
      title: const Text('Petshare'),
      actions: [
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildWelcomeWithNoPets(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Cześć!\n",
        style: Theme.of(context).primaryTextTheme.headlineMedium,
        children: [
          TextSpan(
            text: "Nie masz jeszcze żadnych\nwniosków do rozpatrzenia",
            style: Theme.of(context).primaryTextTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeWithNumberOfApplications(
      BuildContext context, List<MapEntry<Pet, List<Application>>> pets) {
    var numberOfApplications = 0;
    for (var pair in pets) {
      numberOfApplications += pair.value
          .where((application) =>
              application.applicationStatus == ApplicationStatusDTO.Created)
          .length;
    }

    return RichText(
      text: TextSpan(
        text: "Cześć!\n",
        style: Theme.of(context).primaryTextTheme.headlineMedium,
        children: [
          TextSpan(
            text: "Czeka na ciebie ",
            style: Theme.of(context).primaryTextTheme.bodyMedium,
            children: [
              TextSpan(
                text: "$numberOfApplications\n",
                style: Theme.of(context).primaryTextTheme.bodyMedium?.copyWith(
                      color: _interestToColor(numberOfApplications),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const TextSpan(text: "wniosków do rozpatrzenia!")
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcome(
      BuildContext context, List<MapEntry<Pet, List<Application>>> pets) {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    "images/dog_reading.jpg",
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.bottomLeft,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 1,
                          minWidth: 1,
                        ),
                        child: pets.isEmpty
                            ? _buildWelcomeWithNoPets(context)
                            : _buildWelcomeWithNumberOfApplications(
                                context, pets),
                      ),
                    ),
                  ),
                  Flexible(
                    child: InputChip(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                NewAnnouncementForm(context.read())),
                      ),
                      label:
                          const Row(mainAxisSize: MainAxisSize.min, children: [
                        Text("Dodaj ogłoszenie"),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.create,
                          size: 12,
                        )
                      ]),
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            )
          ],
        ));
  }

  Widget _buildPetList(
      BuildContext context, List<MapEntry<Pet, List<Application>>> pets) {
    return SliverList(
      delegate:
          SliverChildBuilderDelegate(childCount: pets.length, (context, index) {
        var applicationsCount = pets[index]
            .value
            .where((application) =>
                application.applicationStatus == ApplicationStatusDTO.Created)
            .length;

        return Card(
          child: ListTile(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ReceivedApplications(
                  context.read(),
                ),
              ),
            ),
            contentPadding: const EdgeInsets.all(8.0),
            leading: SizedBox.square(
              dimension: 50,
              child: ClipOval(
                child: pets[index].key.photoUrl != null
                    ? CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: pets[index].key.photoUrl!,
                      )
                    : const Icon(Icons.pets_outlined),
              ),
            ),
            title: Text(
              pets[index].key.name,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Chip(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  label: Text(applicationsCount.toString()),
                  backgroundColor: _interestToColor(applicationsCount),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: FutureBuilder(
        future: context.read<AdopterService>().getApplications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CatProgressIndicator());
          }

          if (snapshot.hasError || (snapshot.data == null)) {
            return const Center(child: Text("Wystąpił błąd"));
          }

          var pets =
              groupBy(snapshot.data!, (Application a) => a.announcement.pet)
                  .entries
                  .toList();

          return ListHeaderView(
              header: _buildWelcome(context, pets),
              slivers: [_buildPetList(context, pets)]);
        },
      ),
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
      appBar: _buildAppbar(context),
      body: _buildBody(context),
    );
  }
}

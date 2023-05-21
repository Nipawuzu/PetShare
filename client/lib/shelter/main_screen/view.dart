import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:collection/collection.dart";
import 'package:pet_share/announcements/form/view.dart';
import 'package:pet_share/announcements/models/pet.dart';
import 'package:pet_share/applications/application.dart';
import 'package:pet_share/common_widgets/drawer.dart';
import 'package:pet_share/common_widgets/gif_views.dart';
import 'package:pet_share/common_widgets/list_header_view.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/services/service_response.dart';
import 'package:pet_share/shelter/pet_details/view.dart';

class ShelterMainScreen extends StatefulWidget {
  const ShelterMainScreen({super.key});

  @override
  State<ShelterMainScreen> createState() => _ShelterMainScreenState();
}

class _ShelterMainScreenState extends State<ShelterMainScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
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

  String _formatWaiting(int numberOfApplications) {
    if (numberOfApplications < 5 && numberOfApplications > 1) return "Czekają";

    return "Czeka";
  }

  String _formatApplications(int numberOfApplications) {
    switch (numberOfApplications % 10) {
      case 1:
        return "wniosek";
      case 2:
      case 3:
      case 4:
        return "$numberOfApplications wnioski";
      default:
        return "$numberOfApplications wniosków";
    }
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
            text: "${_formatWaiting(numberOfApplications)} na ciebie ",
            style: Theme.of(context).primaryTextTheme.bodyMedium,
            children: [
              TextSpan(
                text: "$numberOfApplications\n",
                style: Theme.of(context).primaryTextTheme.bodyMedium?.copyWith(
                      color: _interestToColor(numberOfApplications),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextSpan(
                  text:
                      "${_formatApplications(numberOfApplications)} do rozpatrzenia!")
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeWhenError(BuildContext context) {
    return Text("Cześć!",
        style: Theme.of(context).primaryTextTheme.headlineMedium);
  }

  Widget _buildWelcome(
      BuildContext context, List<MapEntry<Pet, List<Application>>>? pets) {
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
                        child: pets == null
                            ? _buildWelcomeWhenError(context)
                            : pets.isEmpty
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
            // onTap: () => Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => ReceivedApplications(
            //       context.read(),
            //     ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => PetDetails(
                        pet: pets[index].key,
                        applications: pets[index].value,
                      )),
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

          if (snapshot.hasError ||
              snapshot.data == null ||
              snapshot.data!.data == null) {
            return Column(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 2 / 9),
                  child: _buildWelcome(context, null),
                ),
                snapshot.data != null &&
                        snapshot.data!.error == ErrorType.unauthorized
                    ? const Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CatForbiddenView(
                            text: Text("Brak dostępu"),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Transform.scale(
                          scale: 0.75,
                          child: const RabbitErrorScreen(
                            text:
                                Text("Wystapił błąd podczas pobierania danych"),
                          ),
                        ),
                      ),
              ],
            );
          }

          var pets = groupBy(
                  snapshot.data!.data!, (Application a) => a.announcement.pet)
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
      key: _scaffoldKey,
      appBar: _buildAppbar(context),
      drawer: const AppDrawer(),
      body: _buildBody(context),
    );
  }
}

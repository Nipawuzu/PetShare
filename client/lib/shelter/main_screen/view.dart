import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:collection/collection.dart";
import 'package:pet_share/announcements/details/view.dart';
import 'package:pet_share/announcements/form/view.dart';
import 'package:pet_share/announcements/models/pet.dart';
import 'package:pet_share/applications/application.dart';
import 'package:pet_share/common_widgets/drawer.dart';
import 'package:pet_share/common_widgets/generic_main_view.dart';
import 'package:pet_share/common_widgets/gif_views.dart';
import 'package:pet_share/common_widgets/interest_to_color.dart';
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
        return "wnioski";
      default:
        return "wniosków";
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
                      color: interestToColor(numberOfApplications),
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
    return SizedBox(
      height: MediaQuery.of(context).size.height * 2 / 9,
      child: Padding(
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
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Flexible(
                        child: InputChip(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    NewAnnouncementForm(context.read())),
                          ),
                          label: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextWithBasicStyle(
                                  text: "Dodaj ogłoszenie",
                                  textScaleFactor: 1,
                                  bold: true,
                                ),
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
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              )
            ],
          )),
    );
  }

  Widget _buildPetList(
      BuildContext context, List<MapEntry<Pet, List<Application>>>? pets) {
    pets = pets ?? [];
    return SliverList(
      delegate:
          SliverChildBuilderDelegate(childCount: pets.length, (context, index) {
        var applicationsCount = pets![index]
            .value
            .where((application) =>
                application.applicationStatus == ApplicationStatusDTO.Created)
            .length;

        return Card(
          child: ListTile(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => PetDetails(
                        pet: pets![index].key,
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
                  backgroundColor: interestToColor(applicationsCount),
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

  Future<ServiceResponse<List<MapEntry<Pet, List<Application>>>?>>
      getApplicationsWithPets(
          List<MapEntry<Pet, List<Application>>>? oldValue) async {
    var newValue = await context.read<AdopterService>().getApplications();
    if (newValue.data != null) {
      return ServiceResponse(
          data: groupBy(newValue.data!, (Application a) => a.announcement.pet)
              .entries
              .toList());
    }
    return ServiceResponse(data: null, error: newValue.error);
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: FutureBuilder(
        future: context.read<AdopterService>().getApplications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: LayoutBuilder(builder: (context, constraint) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxHeight: constraint.maxHeight),
                    child: Expanded(
                      child: Column(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 300),
                            child: _buildWelcome(context, null),
                          ),
                          const Expanded(
                            child: Center(
                                child: CatProgressIndicator(
                                    text: TextWithBasicStyle(
                              text: "Wczytywanie wniosków...",
                              textScaleFactor: 1.7,
                            ))),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          }
          var pets = snapshot.data != null && snapshot.data!.data != null
              ? groupBy(snapshot.data!.data!,
                  (Application a) => a.announcement.pet).entries.toList()
              : null;

          return GenericMainView(
              data: ServiceResponse(data: pets),
              onRefresh: getApplicationsWithPets,
              welcomeBuilder: _buildWelcome,
              itemBuilder: _buildPetList);
        },
      ),
    );
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

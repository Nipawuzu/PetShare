import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pet_share/announcements/details/view.dart';
import 'package:pet_share/application.dart';

class ApplicationDetails extends StatelessWidget {
  const ApplicationDetails(this.application, {super.key});

  final Application application;

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text(
        "Wniosek o adopcję",
        style: TextStyle(color: Colors.white),
      ),
      titleSpacing: 5,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildPetInfo(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints.tightFor(
            height: 400,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            child: CachedNetworkImage(
                imageUrl: application.announcement.pet.photoUrl ??
                    "https://cataas.com/cat?=3",
                fit: BoxFit.cover),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Colors.orange.shade500,
                    width: 6,
                  ),
                ),
                gradient: LinearGradient(
                  transform: const GradientRotation(pi / 4),
                  stops: const [0.015, 0.4, 0.5, 0.85, 1],
                  colors: [
                    Colors.white,
                    Colors.grey.shade50,
                    Colors.grey.shade100,
                    Colors.grey.shade200,
                    Colors.grey.shade300,
                  ],
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: -8.0,
                  children: [
                    Chip(
                      label: Text("Imię: ${application.announcement.pet.name}"),
                    ),
                    Chip(
                        label: Text(
                            "Rasa: ${application.announcement.pet.breed}")),
                    Chip(
                        label:
                            Text("Data wniosku: ${application.creationDate}")),
                    ActionChip(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AnnouncementAndPetDetails(
                              announcement: application.announcement),
                        ),
                      ),
                      backgroundColor: Colors.grey.shade200,
                      label: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Ogłoszenie"),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildApplicationData(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.grey.shade50,
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints.tightFor(width: double.infinity),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Imię i nazwisko",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      application.adopter.userName,
                      style: Theme.of(context).primaryTextTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          Card(
            color: Colors.grey.shade50,
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints.tightFor(width: double.infinity),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Adres zamieszkania",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      application.adopter.address.toString(),
                      style: Theme.of(context).primaryTextTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPetInfo(context),
        _buildApplicationData(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: const ApplicationBottomAppBar(),
    );
  }
}

class ApplicationBottomAppBar extends StatelessWidget {
  const ApplicationBottomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey.shade100)),
                    onPressed: () {},
                    child: const Text("Kontakt")),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Decyzja"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

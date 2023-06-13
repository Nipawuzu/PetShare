import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/announcements/details/view.dart';
import 'package:pet_share/applications/application.dart';
import 'package:pet_share/common_widgets/dialogs.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/utils/datetime_format.dart';

class ApplicationDetails extends StatefulWidget {
  const ApplicationDetails(this.application, {super.key});

  final Application application;

  @override
  State<ApplicationDetails> createState() => _ApplicationDetailsState();
}

class _ApplicationDetailsState extends State<ApplicationDetails> {
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
                imageUrl: widget.application.announcement.pet.photoUrl ??
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
                      label: Text(
                          "Imię: ${widget.application.announcement.pet.name}"),
                    ),
                    if (widget.application.announcement.pet.breed.isNotEmpty)
                      Chip(
                          label: Text(
                              "Rasa: ${widget.application.announcement.pet.breed}")),
                    Chip(
                        label: Text(
                            "Data wniosku: ${widget.application.creationDate.formatDay()}")),
                    Chip(
                      label: Text(
                        "Status: ${applicationStatusToString(widget.application.applicationStatus)}",
                      ),
                      backgroundColor: applicationStatusToColor(
                              widget.application.applicationStatus)
                          .shade200,
                    ),
                    ActionChip(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AnnouncementAndPetDetails(
                              announcement: widget.application.announcement),
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
                      widget.application.adopter.userName,
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
                      widget.application.adopter.address.toString(),
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

  _buildDecisionList(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 4,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.grey.shade100)),
              onPressed: () => showAlertDialog(
                context,
                "zaakceptować",
                TextSubject.application,
                (Application application) {
                  setState(() {
                    application.applicationStatus =
                        ApplicationStatusDTO.Accepted;
                  });
                  return context
                      .read<AdopterService>()
                      .acceptApplication(application.id);
                },
                (Application application) {
                  application.applicationStatus = ApplicationStatusDTO.Created;
                },
                widget.application,
              ),
              child: const TextWithBasicStyle(text: "Zaakceptuj wniosek"),
            ),
            const SizedBox(
              width: 16,
            ),
            ElevatedButton(
              onPressed: () => showAlertDialog(
                context,
                "odrzucić",
                TextSubject.application,
                (Application application) {
                  setState(() {
                    application.applicationStatus =
                        ApplicationStatusDTO.Rejected;
                  });
                  return context
                      .read<AdopterService>()
                      .rejectApplication(application.id);
                },
                (Application application) {
                  application.applicationStatus = ApplicationStatusDTO.Created;
                },
                widget.application,
              ),
              child: const TextWithBasicStyle(text: "Odrzuć wniosek"),
            ),
          ],
        ),
        TextButton(
          child: const TextWithBasicStyle(
            text: "Zamknij",
            textScaleFactor: 1.2,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildApplicationBottomAppBar(BuildContext context) {
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
                  onPressed: widget.application.applicationStatus !=
                          ApplicationStatusDTO.Created
                      ? null
                      : () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => _buildDecisionList(context),
                          );
                        },
                  child: const Text("Decyzja"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPetInfo(context),
          _buildApplicationData(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildApplicationBottomAppBar(context),
    );
  }
}

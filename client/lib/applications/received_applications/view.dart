import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/announcements/details/view.dart';
import 'package:pet_share/applications/application.dart';
import 'package:pet_share/applications/details/view.dart';
import 'package:pet_share/applications/received_applications/cubit.dart';
import 'package:pet_share/applications/service.dart';
import 'package:pet_share/common_widgets/custom_text_field.dart';
import 'package:pet_share/common_widgets/image.dart';
import 'package:pet_share/utils/datetime_format.dart';

class ReceivedApplications extends StatelessWidget {
  const ReceivedApplications(this.applicationService, {super.key});

  final ApplicationService applicationService;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListOfApplicationsCubit(applicationService),
      child: BlocBuilder<ListOfApplicationsCubit, ApplicationsViewState>(
        builder: (context, state) {
          if (state is LoadingListOfApplicationsState) {
            return const LoadingScreen();
          } else if (state is NewestApplicationsListState) {
            return ReceivedApplicationList(
                message: "Najnowsze", applications: state.applications);
          } else if (state is LastlyUpdatedApplicationsListState) {
            return ReceivedApplicationList(
                message: "Ostatnio zmienione",
                applications: state.applications);
          }

          return Container();
        },
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
        ),
      ),
    );
  }
}

class ReceivedApplicationList extends StatelessWidget {
  const ReceivedApplicationList(
      {required this.message, required this.applications, super.key});

  final String message;
  final List<Application> applications;

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Aplikacje adopcyjne"),
      actions: <Widget>[
        PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem<int>(
                value: 0,
                child: TextWithBasicStyle(text: "Najnowsze zgłoszenia")),
            const PopupMenuItem<int>(
              value: 1,
              child: TextWithBasicStyle(text: "Niedawno zmodyfikowane"),
            )
          ],
          onSelected: (value) {
            switch (value) {
              case 0:
                context
                    .read<ListOfApplicationsCubit>()
                    .changeToNewlyAddedApplications();
                break;
              case 1:
                context
                    .read<ListOfApplicationsCubit>()
                    .changeToRecentlyUpdatedApplications();
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 30,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () =>
                context.read<ListOfApplicationsCubit>().refreshApplications(),
            child: ListView.builder(
              itemCount: applications.length,
              itemBuilder: (context, index) =>
                  ApplicationTile(applications[index]),
            ),
          ),
        )
      ]),
    );
  }
}

class ApplicationTile extends StatelessWidget {
  const ApplicationTile(this.application, {super.key});

  final Application application;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ApplicationDetails(application),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.orange, width: 3),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ImageWidget(image: application.announcement.pet.photoUrl),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TileTitle(application: application),
                  CustomTextField(
                    firstText: "Ogłoszenie: ",
                    secondText: application.announcement.title,
                    isFirstTextInBold: true,
                  ),
                  CustomTextField(
                    firstText: "Data zgłoszenia: ",
                    secondText: application.dateOfApplication.formatDay(),
                    isFirstTextInBold: true,
                  ),
                  CustomTextField(
                    firstText: "Ostatnia modyfikacja: ",
                    secondText: application.lastUpdateDate.formatDay(),
                    isFirstTextInBold: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TileTitle extends StatelessWidget {
  const TileTitle({
    super.key,
    required this.application,
  });

  final Application application;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: RichText(
          textAlign: TextAlign.center,
          maxLines: 1,
          text: TextSpan(
              style: const TextStyle(
                  fontFamily: "Quicksand", color: Colors.black, fontSize: 15),
              children: [
                TextSpan(
                    text: application.user.userName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const TextSpan(text: " "),
                TextSpan(text: application.user.address.city)
              ])),
    );
  }
}

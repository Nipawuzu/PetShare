import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/announcements/details/view.dart';
import 'package:pet_share/applications/application.dart';
import 'package:pet_share/applications/details/view.dart';
import 'package:pet_share/applications/received_applications/cubit.dart';
import 'package:pet_share/common_widgets/cat_progess_indicator.dart';
import 'package:pet_share/common_widgets/custom_text_field.dart';
import 'package:pet_share/common_widgets/image.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/utils/datetime_format.dart';

class ReceivedApplications extends StatelessWidget {
  const ReceivedApplications(this.adopterService, {super.key});

  final AdopterService adopterService;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListOfApplicationsCubit(adopterService),
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
      body: CatProgressIndicator(
        text: Text("Wczytywanie wniosków..."),
      ),
    );
  }
}

enum SortMethod { newlyAdded, recentlyUpdated }

class ReceivedApplicationList extends StatefulWidget {
  const ReceivedApplicationList(
      {required this.message, required this.applications, super.key});

  final String message;
  final List<Application> applications;

  @override
  State<ReceivedApplicationList> createState() =>
      _ReceivedApplicationListState();
}

class _ReceivedApplicationListState extends State<ReceivedApplicationList> {
  SortMethod pickedSortMethod = SortMethod.newlyAdded;

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Wnioski adopcyjne"),
      actions: <Widget>[
        PopupMenuButton(
          icon: const Icon(Icons.sort),
          itemBuilder: (context) => [
            CheckedPopupMenuItem<int>(
                checked: pickedSortMethod == SortMethod.newlyAdded,
                value: SortMethod.newlyAdded.index,
                child: const TextWithBasicStyle(text: "Najnowsze zgłoszenia")),
            CheckedPopupMenuItem<int>(
              checked: pickedSortMethod == SortMethod.recentlyUpdated,
              value: SortMethod.recentlyUpdated.index,
              child: const TextWithBasicStyle(text: "Niedawno zmodyfikowane"),
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

            pickedSortMethod = SortMethod.values[value];
          },
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.builder(
      itemCount: widget.applications.length,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ApplicationDetails(
                widget.applications[index],
              ),
            ),
          ),
          leading: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.pets)]),
          title: Text(widget.applications[index].user.userName),
          subtitle: Text(
              "Data: ${widget.applications[index].dateOfApplication.formatDay()}"),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Text(
            widget.message,
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
            child: _buildList(context),
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

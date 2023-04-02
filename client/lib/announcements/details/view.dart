import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pet_share/announcements/added_announcements/cubit.dart';
import 'package:pet_share/announcements/added_announcements/view.dart';
import 'package:pet_share/announcements/announcement.dart';
import 'package:pet_share/announcements/pet.dart';
import 'package:url_launcher/url_launcher.dart';

class AnnouncementAndPetDetails extends StatelessWidget {
  const AnnouncementAndPetDetails({super.key, required this.announcement});
  final Announcement announcement;

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () => context.read<ListOfAnnouncementsCubit>().goBack(),
          icon: const Icon(Icons.arrow_back)),
      actions: <Widget>[
        _buildPopUpMenuButton(context),
      ],
      titleSpacing: 0,
      title: const Text('Wybrane ogłoszenie'),
    );
  }

  PopupMenuButton _buildPopUpMenuButton(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        const PopupMenuItem<int>(
          value: 0,
          child: Text(
            "Usuń ogłoszenie",
            style: TextStyle(
              fontFamily: "Quicksand",
            ),
          ),
        ),
      ],
      onSelected: (item) => {
        if (item == 0) showDialogWhenDeletingAnnouncement(context, announcement)
      },
    );
  }

  void showDialogWhenDeletingAnnouncement(
      BuildContext context, Announcement announcement) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text(
          'Czy na pewno chcesz usunąć to ogłoszenie?',
          textScaleFactor: 1.2,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Quicksand",
          ),
        ),
        actions: <Widget>[
          Row(
            children: [
              _buildDeleteButton(context, 'Tak', true),
              _buildDeleteButton(context, 'Anuluj', false)
            ],
          )
        ],
      ),
    ).then((value) => {
          if (value != null && value)
            {
              announcement.status = AnnouncementStatus.removed,
              context.read<ListOfAnnouncementsCubit>().goBack(),
            }
        });
  }

  Widget _buildDeleteButton(
      BuildContext context, String text, bool doesDelete) {
    return Expanded(
      child: TextButton(
        onPressed: () => {Navigator.pop(context, doesDelete)},
        child: Text(
          text,
          textScaleFactor: 1.2,
          style: const TextStyle(
            fontFamily: "Quicksand",
          ),
        ),
      ),
    );
  }

  Widget _buildInputs(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PetDetails(pet: announcement.pet),
          AnnouncementDetails(announcement: announcement),
        ],
      ),
    );
  }

  Widget _buildContactList(BuildContext context) {
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
        Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "Skontaktuj się ze schroniskiem ${announcement.shelter.fullShelterName}",
              textScaleFactor: 1.3,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "Quicksand",
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildContactButton(
                context,
                "Zadzwoń",
                Icons.phone,
                () => CallUtils.openDialer(
                    announcement.shelter.phoneNumber, context)),
            _buildContactButton(
                context,
                "Napisz maila",
                Icons.email,
                () => CallUtils.openDialerForEmail(
                    announcement.shelter.email, context)),
          ],
        ),
        TextButton(
          child: const Text(
            'Zamknij',
            textScaleFactor: 1.2,
            style: TextStyle(
              fontFamily: "Quicksand",
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildContactButton(
      BuildContext context, String text, IconData icon, Function onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: onPressed as void Function()?,
          icon: Icon(icon),
          label: Text(
            text,
            style: const TextStyle(
              fontFamily: "Quicksand",
            ),
          ),
        ),
      ),
    );
  }

  BottomAppBar _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => _buildContactList(context),
                  );
                },
                child: const Text(
                  "Kontakt",
                  style: TextStyle(
                      fontFamily: "Quicksand", fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  "Aplikuj",
                  style: TextStyle(
                      fontFamily: "Quicksand", fontWeight: FontWeight.bold),
                )),
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<ListOfAnnouncementsCubit>().goBack();
        return false;
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        bottomNavigationBar: _buildBottomAppBar(context),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildInputs(context),
        ),
      ),
    );
  }
}

class CallUtils {
  CallUtils._();

  static Future<void> openDialer(
      String phoneNumber, BuildContext context) async {
    Uri callUrl = Uri(scheme: 'tel', path: phoneNumber);
    open(callUrl, context);
  }

  static Future<void> openDialerForEmail(
      String email, BuildContext context) async {
    Uri callUrl = Uri(scheme: 'mailto', path: email);
    open(callUrl, context);
  }

  static Future<void> open(Uri uri, BuildContext context) async {
    try {
      await launchUrl(uri);
    } catch (e) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Nie udała się próba połączenia ze schroniskiem'),
          content: const Text('Spróbuj ponownie później'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

class AnnouncementDetails extends StatelessWidget {
  const AnnouncementDetails({super.key, required this.announcement});
  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Dane ogłoszenia: ",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.orange,
          ),
        ),
        CustomTextField(
          firstText: "Tytuł ogłoszenia: ",
          secondText: announcement.title,
          isFirstTextInBold: true,
        ),
        CustomTextField(
          firstText: "Opis zwierzątka: ",
          secondText: announcement.description,
          isFirstTextInBold: true,
        ),
        CustomTextField(
          firstText: "Schronisko: ",
          secondText: announcement.shelter.fullShelterName,
          isFirstTextInBold: true,
        ),
        CustomTextField(
          firstText: "Status ogłoszenia: ",
          secondText: statusToString(announcement.status),
          isFirstTextInBold: true,
          secondTextColor: statusToColor(announcement.status),
        ),
      ],
    );
  }
}

class PetDetails extends StatelessWidget {
  const PetDetails({super.key, required this.pet});
  final Pet pet;

  String _formatDate(DateTime? date) {
    return date != null ? DateFormat('dd.MM.yyyy').format(date) : "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ImageWidget(
            size: 200,
            image: pet.photo != null ? Image.memory(pet.photo!) : null,
          ),
        ),
        const Text(
          "Dane zwierzątka: ",
          style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.orange),
        ),
        CustomTextField(
          firstText: "Imię zwierzątka: ",
          secondText: pet.name,
          isFirstTextInBold: true,
        ),
        CustomTextField(
          firstText: "Wiek zwierzątka: ",
          secondText: _formatDate(pet.birthday),
          isFirstTextInBold: true,
        ),
        CustomTextField(
          firstText: "Gatunek: ",
          secondText: pet.species,
          isFirstTextInBold: true,
        ),
        CustomTextField(
          firstText: "Rasa: ",
          secondText: pet.breed,
          isFirstTextInBold: true,
        ),
        CustomTextField(
          firstText: "Opis zwierzątka: ",
          secondText: pet.description,
          isFirstTextInBold: true,
        ),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.firstText,
    required this.secondText,
    this.isFirstTextInBold = false,
    this.secondTextColor = Colors.black,
  });
  final String firstText, secondText;
  final bool isFirstTextInBold;
  final Color secondTextColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text.rich(TextSpan(
          text: firstText,
          style: TextStyle(
            fontFamily: "Quicksand",
            fontSize: 15,
            fontWeight: isFirstTextInBold ? FontWeight.bold : FontWeight.normal,
          ),
          children: [
            TextSpan(
              text: secondText,
              style: TextStyle(
                fontFamily: "Quicksand",
                fontSize: 15,
                color: secondTextColor,
                fontWeight: FontWeight.normal,
              ),
            ),
          ])),
    );
  }
}

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, required this.size, required this.image});

  final double size;
  final Image? image;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(20)),
        child: SizedBox.square(
          dimension: size,
          child: image ??
              const Icon(
                Icons.camera_alt_outlined,
                size: 64,
              ),
        ),
      ),
    );
  }
}

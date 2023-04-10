import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pet_share/announcements/added_announcements/cubit.dart';
import 'package:pet_share/announcements/added_announcements/view.dart';
import 'package:pet_share/announcements/announcement.dart';
import 'package:pet_share/announcements/pet.dart';
import 'package:pet_share/common_widgets/custom_text_field.dart';
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
      title: const TextWithBasicStyle(text: 'Wybrane ogłoszenie'),
    );
  }

  PopupMenuButton _buildPopUpMenuButton(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        const PopupMenuItem<int>(
          value: 0,
          child: TextWithBasicStyle(
            text: "Usuń ogłoszenie",
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
        content: const TextWithBasicStyle(
          text: 'Czy na pewno chcesz usunąć to ogłoszenie?',
          textScaleFactor: 1.2,
          align: TextAlign.center,
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
              context
                  .read<ListOfAnnouncementsCubit>()
                  .deleteAnnouncement(announcement),
            }
        });
  }

  Widget _buildDeleteButton(
      BuildContext context, String text, bool doesDelete) {
    return Expanded(
      child: TextButton(
        onPressed: () => {Navigator.pop(context, doesDelete)},
        child: TextWithBasicStyle(
          text: text,
          textScaleFactor: 1.2,
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

  Widget _buildAddress(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: TextWithBasicStyle(
          // ignore: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation
          text: "ul. ${announcement.pet.shelter.address.street}, ${announcement.pet.shelter.address.postalCode} " +
              "${announcement.pet.shelter.address.city}\n ${announcement.pet.shelter.address.province}, " +
              // ignore: unnecessary_string_interpolations
              "${announcement.pet.shelter.address.country}",
          textScaleFactor: 1.2,
          align: TextAlign.center,
        ),
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
            child: TextWithBasicStyle(
              text:
                  "Skontaktuj się ze schroniskiem ${announcement.pet.shelter.fullShelterName}",
              textScaleFactor: 1.3,
              align: TextAlign.center,
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
                    announcement.pet.shelter.phoneNumber, context)),
            _buildContactButton(
                context,
                "Napisz maila",
                Icons.email,
                () => CallUtils.openDialerForEmail(
                    announcement.pet.shelter.email, context)),
          ],
        ),
        _buildAddress(context),
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

  Widget _buildContactButton(
      BuildContext context, String text, IconData icon, Function onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
            onPressed: onPressed as void Function()?,
            icon: Icon(icon),
            label: TextWithBasicStyle(
              text: text,
            )),
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
                child: const BoldTextWithBasicStyle(
                  text: "Kontakt",
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                onPressed: () {},
                child: const BoldTextWithBasicStyle(
                  text: "Aplikuj",
                ),
              ),
            ),
          ),
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
          secondText: announcement.pet.shelter.fullShelterName,
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
        if (pet.photoUrl != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                height: 200,
                child: CachedNetworkImage(
                  imageUrl: pet.photoUrl!,
                ),
              ),
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

class TextWithBasicStyle extends StatelessWidget {
  const TextWithBasicStyle(
      {super.key, required this.text, this.textScaleFactor = 1.0, this.align});

  final String text;
  final double textScaleFactor;
  final TextAlign? align;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textScaleFactor: textScaleFactor,
      textAlign: align,
      style: const TextStyle(
        fontFamily: "Quicksand",
      ),
    );
  }
}

class BoldTextWithBasicStyle extends StatelessWidget {
  const BoldTextWithBasicStyle(
      {super.key, required this.text, this.textScaleFactor = 1.0});

  final String text;
  final double textScaleFactor;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textScaleFactor: textScaleFactor,
      style: const TextStyle(
        fontFamily: "Quicksand",
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

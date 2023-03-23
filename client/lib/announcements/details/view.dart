import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pet_share/announcements/added_announcements/cubit.dart';
import 'package:pet_share/announcements/added_announcements/view.dart';
import 'package:pet_share/announcements/announcement.dart';
import 'package:pet_share/announcements/pet.dart';

class AnnouncementAndPetDetails extends StatelessWidget {
  const AnnouncementAndPetDetails({super.key, required this.announcement});
  final Announcement announcement;

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () => context.read<ListOfAnnouncementsCubit>().goBack(),
          icon: const Icon(Icons.arrow_back)),
      titleSpacing: 0,
      title: const Text('Wybrane ogłoszenie'),
    );
  }

  Widget _buildInputs(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnnouncementDetails(announcement: announcement),
          PetDetails(pet: announcement.pet)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildInputs(context),
      ),
    );
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
        const Text(
          "Dane zwierzątka: ",
          style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.orange),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ImageWidget(
            size: 200,
            image: pet.photo != null ? Image.memory(pet.photo!) : null,
          ),
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
        child: InkWell(
          onTap: () {},
          child: SizedBox.square(
            dimension: size,
            child: image ??
                const Icon(
                  Icons.camera_alt_outlined,
                  size: 64,
                ),
          ),
        ),
      ),
    );
  }
}

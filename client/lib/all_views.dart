import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/address.dart';
import 'package:pet_share/annoucements/added_announcements/view.dart';
import 'package:pet_share/annoucements/announcement.dart';
import 'package:pet_share/annoucements/form/view.dart';
import 'package:pet_share/annoucements/pet.dart';
import 'package:pet_share/shelter.dart';

class AllViews extends StatelessWidget {
  const AllViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          ViewsListTile(
            text: "Dodaj nowe ogłoszenie",
            image: const AssetImage("images/new_announcement.png"),
            child: NewAnnoucementForm(context.read()),
          ),
          ViewsListTile(
            text: "Dodane ogłoszenia",
            child: AddedAnnouncements(
              announcements: [
                Announcement(
                  description:
                      "AlaMaKota taki mega mega mega mega mega mega mega mega mega mega mega mega długi opis",
                  pet: Pet(
                      name: "Nola",
                      species: "kotek",
                      breed: "szara",
                      description: "Jest super",
                      photo: null),
                  title: "Zajebista kotka, nie oddam",
                  shelter: Shelter(
                    address: Address(
                        country: 'Polsza',
                        city: "Warszawka",
                        postalCode: "02-656",
                        street: "Kotkowa",
                        province: "Mazowwieckie"),
                    email: 'loloo',
                    fullShelterName: 'szelterek',
                    userName: 'sada',
                    phoneNumber: '21213',
                  ),
                ),
                Announcement(
                  description:
                      "chce kotkaaaaaaaa, długi opis bo można, a czemu by nie",
                  pet: Pet(
                      name: "Mela",
                      species: "kotek",
                      breed: "ruda",
                      description: "Jest super",
                      photo: null),
                  title: "Zajebista druga kotka, nie oddam",
                  shelter: Shelter(
                    address: Address(
                        country: 'Polsza',
                        city: "Warszawka",
                        postalCode: "02-656",
                        street: "Kotkowa",
                        province: "Mazowwieckie"),
                    email: 'loloo',
                    fullShelterName: 'szelterek taka długa nazwa szelterka',
                    userName: 'sada',
                    phoneNumber: '21213',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ViewsListTile extends StatelessWidget {
  const ViewsListTile({super.key, required this.child, this.text, this.image});

  final Widget child;
  final String? text;
  final ImageProvider? image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SizedBox(
        height: 120,
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => child,
            ),
          ),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    text ?? child.runtimeType.toString(),
                    style: const TextStyle(
                        fontSize: 22,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600),
                  ),
                  if (image != null)
                    const SizedBox(
                      width: 16,
                    ),
                  if (image != null)
                    LayoutBuilder(
                      builder: (context, constraints) => SizedBox(
                        width: constraints.maxHeight * 0.8,
                        child: Image(image: image!),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

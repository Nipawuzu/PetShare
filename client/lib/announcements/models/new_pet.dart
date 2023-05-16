import 'dart:typed_data';

import 'package:pet_share/announcements/models/pet.dart';

class NewPet {
  NewPet({
    this.name = "",
    this.species = "",
    this.birthday,
    this.sex = Sex.Unknown,
    this.breed = "",
    this.description = "",
  });

  String name;
  String species;
  String breed;
  Sex sex;
  DateTime? birthday;
  String description;
  Uint8List? photo;
}

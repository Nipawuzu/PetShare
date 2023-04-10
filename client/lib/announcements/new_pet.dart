import 'dart:typed_data';

class NewPet {
  NewPet({
    this.name = "",
    this.species = "",
    this.birthday,
    this.breed = "",
    this.description = "",
  });

  String name;
  String species;
  String breed;
  DateTime? birthday;
  String description;
  Uint8List? photo;
}

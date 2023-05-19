// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/shelter.dart';

part 'pet.g.dart';

@JsonSerializable()
class Pet {
  Pet(
      {this.name = "",
      this.species = "",
      this.birthday,
      this.breed = "",
      this.sex = Sex.Unknown,
      this.description = "",
      this.photoUrl,
      required this.shelter});

  String? id;
  String name;
  String species;
  String breed;
  Sex sex;
  DateTime? birthday;
  String description;
  String? photoUrl;
  Shelter shelter;

  Map<String, dynamic> toJson() => _$PetToJson(this);
  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);
}

enum Sex {
  Unknown,
  Male,
  Female,
  DoesNotApply,
}

String sexToString(Sex sex) {
  switch (sex) {
    case Sex.Unknown:
      return "nieznana";
    case Sex.Male:
      return "chłop";
    case Sex.Female:
      return "baba";
    case Sex.DoesNotApply:
      return "nie dotyczy";
  }
}

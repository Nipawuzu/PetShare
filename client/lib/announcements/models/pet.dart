import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/shelter.dart';
import 'package:pet_share/utils/sex_converter.dart';

part 'pet.g.dart';

@JsonSerializable()
class Pet {
  Pet(
      {this.name = "",
      this.species = "",
      this.birthday,
      this.breed = "",
      this.sex = Sex.unknown,
      this.description = "",
      this.photoUrl,
      required this.shelter});

  String? id;
  String name;
  String species;
  String breed;
  @SexConverter()
  Sex sex;
  DateTime? birthday;
  String description;
  String? photoUrl;
  Shelter shelter;

  Map<String, dynamic> toJson() => _$PetToJson(this);
  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);
}

enum Sex {
  unknown,
  male,
  female,
  doesNotApply,
}

String sexToString(Sex sex) {
  switch (sex) {
    case Sex.unknown:
      return "nieznana";
    case Sex.male:
      return "chłop";
    case Sex.female:
      return "baba";
    case Sex.doesNotApply:
      return "nie dotyczy";
  }
}

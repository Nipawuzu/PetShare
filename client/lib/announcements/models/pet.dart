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
      this.description = "",
      this.photoUrl,
      required this.shelter});

  String? id;
  String name;
  String species;
  String breed;
  DateTime? birthday;
  String description;
  String? photoUrl;
  Shelter shelter;

  Map<String, dynamic> toJson() => _$PetToJson(this);
  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);
}

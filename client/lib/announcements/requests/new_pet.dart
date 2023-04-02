import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/utils/uint8list_converter.dart';

part 'new_pet.g.dart';

@JsonSerializable()
class NewPet {
  NewPet(
      {this.name = "",
      this.species = "",
      this.birthday,
      this.breed = "",
      this.description = "",
      this.photo});

  String name;
  String species;
  String breed;
  DateTime? birthday;
  String description;

  @Uint8ListConverter()
  Uint8List? photo;

  Map<String, dynamic> toJson() => _$NewPetToJson(this);
  factory NewPet.fromJson(Map<String, dynamic> json) => _$NewPetFromJson(json);
}

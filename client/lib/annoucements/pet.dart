import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Pet {
  Pet(
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
  Uint8List? photo;
}

import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/annoucements/pet.dart';

@JsonSerializable()
class Announcement {
  Announcement(
      {required this.pet, required this.title, required this.description});

  Pet pet;
  String title;
  String description;
}

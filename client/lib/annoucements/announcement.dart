import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/annoucements/pet.dart';
import 'package:pet_share/shelter.dart';

@JsonSerializable()
class Announcement {
  Announcement({
    required this.pet,
    required this.title,
    required this.description,
    required this.shelter,
  });

  Pet pet;
  String title;
  String description;
  Shelter shelter;
  AnnouncementStatus status = AnnouncementStatus.open;
}

enum AnnouncementStatus {
  open,
  closed,
  removed,
  inVerification,
}

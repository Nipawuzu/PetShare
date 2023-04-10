import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/announcements/pet.dart';
import 'package:pet_share/utils/announcementstatus_converter.dart';

part 'announcement.g.dart';

@JsonSerializable()
class Announcement {
  Announcement({
    required this.pet,
    required this.title,
    required this.description,
    this.status = AnnouncementStatus.open,
  });

  Pet pet;
  String title;
  String description;
  @AnnouncementStatusConverter()
  AnnouncementStatus status;
  String? id;

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);
  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);
}

enum AnnouncementStatus {
  open,
  closed,
  removed,
  inVerification,
}

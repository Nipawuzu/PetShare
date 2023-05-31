// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/announcements/models/pet.dart';

part 'announcement.g.dart';

@JsonSerializable()
class Announcement {
  Announcement({
    required this.pet,
    required this.title,
    required this.description,
    this.status = AnnouncementStatus.Open,
  });

  Pet pet;
  String title;
  String description;
  bool? isLiked;
  AnnouncementStatus status;
  String? id;

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);
  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);
}

enum AnnouncementStatus {
  Open,
  Closed,
  Deleted,
}

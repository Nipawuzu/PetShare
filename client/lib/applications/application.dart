import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/adopter.dart';
import 'package:pet_share/announcements/models/announcement.dart';

part 'application.g.dart';

@JsonSerializable()
class Application {
  Application(
      {required this.adopter,
      required this.announcement,
      required this.applicationStatus,
      required this.id,
      required this.creationDate,
      required this.lastUpdateDate,
      required this.announcementId});
  String id;
  DateTime creationDate;
  DateTime lastUpdateDate;
  String announcementId;
  Announcement announcement;
  Adopter adopter;
  ApplicationStatusDTO applicationStatus;

  Map<String, dynamic> toJson() => _$ApplicationToJson(this);
  factory Application.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFromJson(json);
}

// ignore: constant_identifier_names
enum ApplicationStatusDTO { Created, Accepted, Rejected, Withdrawn, Deleted }

String applicationStatusToString(ApplicationStatusDTO status) {
  switch (status) {
    case ApplicationStatusDTO.Created:
      return "utworzone";
    case ApplicationStatusDTO.Accepted:
      return "zaakceptowane";
    case ApplicationStatusDTO.Rejected:
      return "odrzucone";
    case ApplicationStatusDTO.Withdrawn:
      return "wycofane";
    case ApplicationStatusDTO.Deleted:
      return "usunięte";
  }
}

MaterialColor applicationStatusToColor(ApplicationStatusDTO status) {
  switch (status) {
    case ApplicationStatusDTO.Created:
      return Colors.purple;
    case ApplicationStatusDTO.Accepted:
      return Colors.green;
    case ApplicationStatusDTO.Rejected:
      return Colors.red;
    case ApplicationStatusDTO.Withdrawn:
      return Colors.blue;
    case ApplicationStatusDTO.Deleted:
      return Colors.brown;
  }
}

import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/shelter.dart';
part 'application.g.dart';

@JsonSerializable()
class Application {
  Application({
    required this.announcement,
    required this.user,
    required this.dateOfApplication,
    required this.lastUpdateDate,
    this.isWithdrew = false,
  });

  Application.newlyCreated({
    required this.announcement,
    required this.user,
  })  : dateOfApplication = DateTime.now(),
        lastUpdateDate = DateTime.now(),
        isWithdrew = false;

  User user;
  Announcement announcement;
  DateTime dateOfApplication;
  DateTime lastUpdateDate;
  bool isWithdrew;

  Map<String, dynamic> toJson() => _$ApplicationToJson(this);

  factory Application.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFromJson(json);
}

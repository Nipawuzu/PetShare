import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/announcements/announcement.dart';
import 'package:pet_share/utils/announcementstatus_converter.dart';

part 'put_announcement.g.dart';

@JsonSerializable()
class PutAnnouncement {
  PutAnnouncement({
    this.title = '',
    this.description = '',
    this.petId,
    this.status,
  });

  String? petId;
  String? title;
  String? description;
  @AnnouncementStatusConverter()
  AnnouncementStatus? status;

  Map<String, dynamic> toJson() => _$PutAnnouncementToJson(this);
  factory PutAnnouncement.fromJson(Map<String, dynamic> json) =>
      _$PutAnnouncementFromJson(json);
}

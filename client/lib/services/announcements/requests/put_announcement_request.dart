import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/utils/announcementstatus_converter.dart';

part 'put_announcement_request.g.dart';

@JsonSerializable()
class PutAnnouncementRequest {
  PutAnnouncementRequest({
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

  Map<String, dynamic> toJson() => _$PutAnnouncementRequestToJson(this);
  factory PutAnnouncementRequest.fromJson(Map<String, dynamic> json) =>
      _$PutAnnouncementRequestFromJson(json);
}

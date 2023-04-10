import 'package:json_annotation/json_annotation.dart';
part 'post_announcement_request.g.dart';

@JsonSerializable()
class PostAnnouncementRequest {
  PostAnnouncementRequest({
    this.title = '',
    this.description = '',
    this.petId,
  });

  String? petId;
  String title;
  String description;

  Map<String, dynamic> toJson() => _$PostAnnouncementRequestToJson(this);
  factory PostAnnouncementRequest.fromJson(Map<String, dynamic> json) =>
      _$PostAnnouncementRequestFromJson(json);
}

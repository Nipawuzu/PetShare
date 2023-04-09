import 'package:json_annotation/json_annotation.dart';
part 'post_announcement_response.g.dart';

@JsonSerializable()
class PostAnnouncementResponse {
  PostAnnouncementResponse({
    required this.id,
  });

  String id;

  Map<String, dynamic> toJson() => _$PostAnnouncementResponseToJson(this);
  factory PostAnnouncementResponse.fromJson(Map<String, dynamic> json) =>
      _$PostAnnouncementResponseFromJson(json);
}

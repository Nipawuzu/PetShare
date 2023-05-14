import 'package:json_annotation/json_annotation.dart';

part 'put_announcement_like_request.g.dart';

@JsonSerializable()
class PutAnnouncementLikeRequest {
  PutAnnouncementLikeRequest({
    required this.announcementId,
    required this.isLiked,
  });

  String announcementId;
  bool isLiked;

  Map<String, dynamic> toJson() => _$PutAnnouncementLikeRequestToJson(this);
  factory PutAnnouncementLikeRequest.fromJson(Map<String, dynamic> json) =>
      _$PutAnnouncementLikeRequestFromJson(json);
}

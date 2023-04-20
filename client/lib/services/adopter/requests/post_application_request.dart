import 'package:json_annotation/json_annotation.dart';

part 'post_application_request.g.dart';

@JsonSerializable()
class PostApplicationRequest {
  PostApplicationRequest({this.announcementId = '', this.adopterId = ''});

  String announcementId;
  String adopterId;

  Map<String, dynamic> toJson() => _$PostApplicationRequestToJson(this);
  factory PostApplicationRequest.fromJson(Map<String, dynamic> json) =>
      _$PostApplicationRequestFromJson(json);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/announcements/models/announcement.dart';

part 'get_announcements_response.g.dart';

@JsonSerializable()
class GetAnnouncementsResponse {
  final List<Announcement> announcements;
  final int pageNumber;
  final int count;

  GetAnnouncementsResponse(this.pageNumber, this.count, this.announcements);

  Map<String, dynamic> toJson() => _$GetAnnouncementsResponseToJson(this);
  factory GetAnnouncementsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAnnouncementsResponseFromJson(json);
}

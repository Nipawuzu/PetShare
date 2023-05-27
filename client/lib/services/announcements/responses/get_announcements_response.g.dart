// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_announcements_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAnnouncementsResponse _$GetAnnouncementsResponseFromJson(
        Map<String, dynamic> json) =>
    GetAnnouncementsResponse(
      json['pageNumber'] as int,
      json['count'] as int,
      (json['announcements'] as List<dynamic>)
          .map((e) => Announcement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAnnouncementsResponseToJson(
        GetAnnouncementsResponse instance) =>
    <String, dynamic>{
      'announcements': instance.announcements,
      'pageNumber': instance.pageNumber,
      'count': instance.count,
    };

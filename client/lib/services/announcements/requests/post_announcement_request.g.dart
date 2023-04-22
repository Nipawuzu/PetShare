// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_announcement_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostAnnouncementRequest _$PostAnnouncementRequestFromJson(
        Map<String, dynamic> json) =>
    PostAnnouncementRequest(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      petId: json['petId'] as String?,
    );

Map<String, dynamic> _$PostAnnouncementRequestToJson(
        PostAnnouncementRequest instance) =>
    <String, dynamic>{
      'petId': instance.petId,
      'title': instance.title,
      'description': instance.description,
    };

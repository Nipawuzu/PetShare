// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_application_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostApplicationRequest _$PostApplicationRequestFromJson(
        Map<String, dynamic> json) =>
    PostApplicationRequest(
      announcementId: json['announcementId'] as String? ?? '',
      adopterId: json['adopterId'] as String? ?? '',
    );

Map<String, dynamic> _$PostApplicationRequestToJson(
        PostApplicationRequest instance) =>
    <String, dynamic>{
      'announcementId': instance.announcementId,
      'adopterId': instance.adopterId,
    };

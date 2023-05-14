// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_announcement_like_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutAnnouncementLikeRequest _$PutAnnouncementLikeRequestFromJson(
        Map<String, dynamic> json) =>
    PutAnnouncementLikeRequest(
      announcementId: json['announcementId'] as String,
      isLiked: json['isLiked'] as bool,
    );

Map<String, dynamic> _$PutAnnouncementLikeRequestToJson(
        PutAnnouncementLikeRequest instance) =>
    <String, dynamic>{
      'announcementId': instance.announcementId,
      'isLiked': instance.isLiked,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
      pet: Pet.fromJson(json['pet'] as Map<String, dynamic>),
      title: json['title'] as String,
      description: json['description'] as String,
      status:
          $enumDecodeNullable(_$AnnouncementStatusEnumMap, json['status']) ??
              AnnouncementStatus.Open,
    )
      ..isLiked = json['isLiked'] as bool?
      ..id = json['id'] as String?;

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'pet': instance.pet,
      'title': instance.title,
      'description': instance.description,
      'isLiked': instance.isLiked,
      'status': _$AnnouncementStatusEnumMap[instance.status]!,
      'id': instance.id,
    };

const _$AnnouncementStatusEnumMap = {
  AnnouncementStatus.Open: 'Open',
  AnnouncementStatus.Closed: 'Closed',
  AnnouncementStatus.Deleted: 'Deleted',
};

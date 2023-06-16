// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) {
  AnnouncementStatusConverterToString converter =
      const AnnouncementStatusConverterToString();

  return Announcement(
    pet: Pet.fromJson(json['pet'] as Map<String, dynamic>),
    title: json['title'] as String,
    description: json['description'] as String,
    status: converter.fromJson(json["status"]),
  )
    ..isLiked = json['isLiked'] as bool?
    ..id = json['id'] as String?;
}

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

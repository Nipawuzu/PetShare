// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
      pet: Pet.fromJson(json['pet'] as Map<String, dynamic>),
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] == null
          ? AnnouncementStatus.open
          : const AnnouncementStatusConverter().fromJson(json['status'] as int),
    )..id = json['id'] as String?;

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'pet': instance.pet,
      'title': instance.title,
      'description': instance.description,
      'status': const AnnouncementStatusConverter().toJson(instance.status),
      'id': instance.id,
    };

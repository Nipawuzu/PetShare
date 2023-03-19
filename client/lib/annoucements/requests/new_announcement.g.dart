// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewAnnouncement _$NewAnnouncementFromJson(Map<String, dynamic> json) =>
    NewAnnouncement(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      pet: json['pet'] == null
          ? null
          : NewPet.fromJson(json['pet'] as Map<String, dynamic>),
      petId: json['petId'] as String?,
    );

Map<String, dynamic> _$NewAnnouncementToJson(NewAnnouncement instance) =>
    <String, dynamic>{
      'pet': instance.pet,
      'petId': instance.petId,
      'title': instance.title,
      'description': instance.description,
    };

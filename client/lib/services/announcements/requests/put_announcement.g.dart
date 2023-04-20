// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutAnnouncement _$PutAnnouncementFromJson(Map<String, dynamic> json) =>
    PutAnnouncement(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      petId: json['petId'] as String?,
      status: _$JsonConverterFromJson<int, AnnouncementStatus>(
          json['status'], const AnnouncementStatusConverter().fromJson),
    );

Map<String, dynamic> _$PutAnnouncementToJson(PutAnnouncement instance) =>
    <String, dynamic>{
      'petId': instance.petId,
      'title': instance.title,
      'description': instance.description,
      'status': _$JsonConverterToJson<int, AnnouncementStatus>(
          instance.status, const AnnouncementStatusConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
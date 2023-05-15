// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Application _$ApplicationFromJson(Map<String, dynamic> json) => Application(
      adopter: Adopter.fromJson(json['adopter'] as Map<String, dynamic>),
      announcement:
          Announcement.fromJson(json['announcement'] as Map<String, dynamic>),
      status: $enumDecode(_$ApplicationStatusDTOEnumMap, json['status']),
      id: json['id'] as String,
      creationDate: DateTime.parse(json['creationDate'] as String),
      lastUpdateDate: DateTime.parse(json['lastUpdateDate'] as String),
      announcementId: json['announcementId'] as String,
    );

Map<String, dynamic> _$ApplicationToJson(Application instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creationDate': instance.creationDate.toIso8601String(),
      'lastUpdateDate': instance.lastUpdateDate.toIso8601String(),
      'announcementId': instance.announcementId,
      'announcement': instance.announcement,
      'adopter': instance.adopter,
      'status': _$ApplicationStatusDTOEnumMap[instance.status]!,
    };

const _$ApplicationStatusDTOEnumMap = {
  ApplicationStatusDTO.created: 'created',
  ApplicationStatusDTO.accepted: 'accepted',
  ApplicationStatusDTO.rejected: 'rejected',
  ApplicationStatusDTO.withdrawn: 'withdrawn',
  ApplicationStatusDTO.deleted: 'deleted',
};

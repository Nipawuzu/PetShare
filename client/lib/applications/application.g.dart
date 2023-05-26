// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Application _$ApplicationFromJson(Map<String, dynamic> json) => Application(
      adopter: Adopter.fromJson(json['adopter'] as Map<String, dynamic>),
      announcement:
          Announcement.fromJson(json['announcement'] as Map<String, dynamic>),
      applicationStatus:
          $enumDecode(_$ApplicationStatusDTOEnumMap, json['applicationStatus']),
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
      'applicationStatus':
          _$ApplicationStatusDTOEnumMap[instance.applicationStatus]!,
    };

const _$ApplicationStatusDTOEnumMap = {
  ApplicationStatusDTO.Created: 'Created',
  ApplicationStatusDTO.Accepted: 'Accepted',
  ApplicationStatusDTO.Rejected: 'Rejected',
  ApplicationStatusDTO.Withdrawn: 'Withdrawn',
  ApplicationStatusDTO.Deleted: 'Deleted',
};

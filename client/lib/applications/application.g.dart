// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Application _$ApplicationFromJson(Map<String, dynamic> json) => Application(
      announcement:
          Announcement.fromJson(json['announcement'] as Map<String, dynamic>),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      dateOfApplication: DateTime.parse(json['dateOfApplication'] as String),
      lastUpdateDate: DateTime.parse(json['lastUpdateDate'] as String),
      isWithdrew: json['isWithdrew'] as bool? ?? false,
    );

Map<String, dynamic> _$ApplicationToJson(Application instance) =>
    <String, dynamic>{
      'user': instance.user,
      'announcement': instance.announcement,
      'dateOfApplication': instance.dateOfApplication.toIso8601String(),
      'lastUpdateDate': instance.lastUpdateDate.toIso8601String(),
      'isWithdrew': instance.isWithdrew,
    };

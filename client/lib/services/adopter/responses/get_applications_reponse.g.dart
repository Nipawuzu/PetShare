// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_applications_reponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetApplicationsResponse _$GetApplicationsResponseFromJson(
        Map<String, dynamic> json) =>
    GetApplicationsResponse(
      json['pageNumber'] as int,
      json['count'] as int,
      (json['applications'] as List<dynamic>)
          .map((e) => Application.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetApplicationsResponseToJson(
        GetApplicationsResponse instance) =>
    <String, dynamic>{
      'applications': instance.applications,
      'pageNumber': instance.pageNumber,
      'count': instance.count,
    };

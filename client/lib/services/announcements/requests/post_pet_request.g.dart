// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_pet_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostPetRequest _$PostPetRequestFromJson(Map<String, dynamic> json) =>
    PostPetRequest(
      name: json['name'] as String? ?? "",
      species: json['species'] as String? ?? "",
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      sex: json['sex'] == null
          ? Sex.Unknown
          : const SexConverter().fromJson(json['sex']),
      breed: json['breed'] as String? ?? "",
      description: json['description'] as String? ?? "",
      photoUrl: json['photoUrl'] as String? ?? "",
    );

Map<String, dynamic> _$PostPetRequestToJson(PostPetRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'species': instance.species,
      'breed': instance.breed,
      'photoUrl': instance.photoUrl,
      'sex': const SexConverter().toJson(instance.sex),
      'birthday': instance.birthday?.toIso8601String(),
      'description': instance.description,
    };

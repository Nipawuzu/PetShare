// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pet _$PetFromJson(Map<String, dynamic> json) => Pet(
      name: json['name'] as String? ?? "",
      species: json['species'] as String? ?? "",
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      breed: json['breed'] as String? ?? "",
      description: json['description'] as String? ?? "",
      photoUrl: json['photoUrl'] as String?,
      shelter: Shelter.fromJson(json['shelter'] as Map<String, dynamic>),
    )..id = json['id'] as String?;

Map<String, dynamic> _$PetToJson(Pet instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'species': instance.species,
      'breed': instance.breed,
      'birthday': instance.birthday?.toIso8601String(),
      'description': instance.description,
      'photoUrl': instance.photoUrl,
      'shelter': instance.shelter,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_pet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewPet _$NewPetFromJson(Map<String, dynamic> json) => NewPet(
      name: json['name'] as String? ?? "",
      species: json['species'] as String? ?? "",
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      breed: json['breed'] as String? ?? "",
      description: json['description'] as String? ?? "",
      photo: _$JsonConverterFromJson<List<int>, Uint8List>(
          json['photo'], const Uint8ListConverter().fromJson),
    );

Map<String, dynamic> _$NewPetToJson(NewPet instance) => <String, dynamic>{
      'name': instance.name,
      'species': instance.species,
      'breed': instance.breed,
      'birthday': instance.birthday?.toIso8601String(),
      'description': instance.description,
      'photo': _$JsonConverterToJson<List<int>, Uint8List>(
          instance.photo, const Uint8ListConverter().toJson),
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

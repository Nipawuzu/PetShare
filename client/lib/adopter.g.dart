// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adopter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Adopter _$AdopterFromJson(Map<String, dynamic> json) => Adopter(
      id: json['id'] as String,
      userName: json['userName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      status: $enumDecode(_$AdopterStatusDTOEnumMap, json['status']),
    );

Map<String, dynamic> _$AdopterToJson(Adopter instance) => <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'address': instance.address,
      'status': _$AdopterStatusDTOEnumMap[instance.status]!,
    };

const _$AdopterStatusDTOEnumMap = {
  AdopterStatusDTO.Active: 'Active',
  AdopterStatusDTO.Blocked: 'Blocked',
  AdopterStatusDTO.Deleted: 'Deleted',
};

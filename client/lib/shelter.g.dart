// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shelter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      userName: json['userName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'address': instance.address,
    };

Shelter _$ShelterFromJson(Map<String, dynamic> json) => Shelter(
      id: json['id'] as String,
      userName: json['userName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      fullShelterName: json['fullShelterName'] as String,
    )..isAuthorized = json['isAuthorized'] as bool;

Map<String, dynamic> _$ShelterToJson(Shelter instance) => <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'address': instance.address,
      'isAuthorized': instance.isAuthorized,
      'fullShelterName': instance.fullShelterName,
    };

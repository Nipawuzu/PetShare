// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_adopter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewUser _$NewUserFromJson(Map<String, dynamic> json) => NewUser(
      userName: json['userName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      email: json['email'] as String? ?? '',
      address: json['address'] == null
          ? null
          : NewAddress.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NewUserToJson(NewUser instance) => <String, dynamic>{
      'userName': instance.userName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'address': instance.address,
    };

NewAdopter _$NewAdopterFromJson(Map<String, dynamic> json) => NewAdopter()
  ..userName = json['userName'] as String
  ..phoneNumber = json['phoneNumber'] as String
  ..email = json['email'] as String
  ..address = json['address'] == null
      ? null
      : NewAddress.fromJson(json['address'] as Map<String, dynamic>);

Map<String, dynamic> _$NewAdopterToJson(NewAdopter instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'address': instance.address,
    };

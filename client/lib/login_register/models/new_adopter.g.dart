// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_adopter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewUser _$NewUserFromJson(Map<String, dynamic> json) => NewUser(
      userName: json['userName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      dialCode: json['dialCode'] as String? ?? '+48',
      isoCode: json['isoCode'] as String? ?? 'PL',
      email: json['email'] as String? ?? '',
      address: json['address'] == null
          ? null
          : NewAddress.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NewUserToJson(NewUser instance) => <String, dynamic>{
      'userName': instance.userName,
      'phoneNumber': instance.phoneNumber,
      'dialCode': instance.dialCode,
      'isoCode': instance.isoCode,
      'email': instance.email,
      'address': instance.address,
    };

NewAdopter _$NewAdopterFromJson(Map<String, dynamic> json) => NewAdopter(
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      dialCode: json['dialCode'] as String? ?? '+48',
      isoCode: json['isoCode'] as String? ?? 'PL',
      email: json['email'] as String? ?? '',
      address: json['address'] == null
          ? null
          : NewAddress.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NewAdopterToJson(NewAdopter instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'phoneNumber': instance.phoneNumber,
      'dialCode': instance.dialCode,
      'isoCode': instance.isoCode,
      'email': instance.email,
      'address': instance.address,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_shelter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewShelter _$NewShelterFromJson(Map<String, dynamic> json) => NewShelter(
      fullShelterName: json['fullShelterName'] as String? ?? '',
    )
      ..userName = json['userName'] as String
      ..phoneNumber = json['phoneNumber'] as String
      ..email = json['email'] as String
      ..address = json['address'] == null
          ? null
          : NewAddress.fromJson(json['address'] as Map<String, dynamic>);

Map<String, dynamic> _$NewShelterToJson(NewShelter instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'address': instance.address,
      'fullShelterName': instance.fullShelterName,
    };

NewAddress _$NewAddressFromJson(Map<String, dynamic> json) => NewAddress(
      street: json['street'] as String? ?? '',
      city: json['city'] as String? ?? '',
      province: json['province'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
      country: json['country'] as String? ?? '',
    );

Map<String, dynamic> _$NewAddressToJson(NewAddress instance) =>
    <String, dynamic>{
      'street': instance.street,
      'city': instance.city,
      'province': instance.province,
      'postalCode': instance.postalCode,
      'country': instance.country,
    };

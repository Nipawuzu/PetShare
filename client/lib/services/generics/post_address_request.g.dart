// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_address_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostAddressRequest _$PostAddressRequestFromJson(Map<String, dynamic> json) =>
    PostAddressRequest(
      street: json['street'] as String? ?? '',
      city: json['city'] as String? ?? '',
      province: json['province'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
      country: json['country'] as String? ?? '',
    );

Map<String, dynamic> _$PostAddressRequestToJson(PostAddressRequest instance) =>
    <String, dynamic>{
      'street': instance.street,
      'city': instance.city,
      'province': instance.province,
      'postalCode': instance.postalCode,
      'country': instance.country,
    };

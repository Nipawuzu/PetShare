// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_shelter_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostShelterRequest _$PostShelterRequestFromJson(Map<String, dynamic> json) =>
    PostShelterRequest(
      fullShelterName: json['fullShelterName'] as String? ?? '',
    )
      ..userName = json['userName'] as String
      ..phoneNumber = json['phoneNumber'] as String
      ..email = json['email'] as String
      ..address = json['address'] == null
          ? null
          : PostAddressRequest.fromJson(
              json['address'] as Map<String, dynamic>);

Map<String, dynamic> _$PostShelterRequestToJson(PostShelterRequest instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'address': instance.address,
      'fullShelterName': instance.fullShelterName,
    };

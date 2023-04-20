// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_adopter_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostAdopterRequest _$PostAdopterRequestFromJson(Map<String, dynamic> json) =>
    PostAdopterRequest(
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
    )
      ..userName = json['userName'] as String
      ..phoneNumber = json['phoneNumber'] as String
      ..email = json['email'] as String
      ..address = json['address'] == null
          ? null
          : PostAddressRequest.fromJson(
              json['address'] as Map<String, dynamic>);

Map<String, dynamic> _$PostAdopterRequestToJson(PostAdopterRequest instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'address': instance.address,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

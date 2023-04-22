// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostUserRequest _$PostUserRequestFromJson(Map<String, dynamic> json) =>
    PostUserRequest(
      userName: json['userName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      email: json['email'] as String? ?? '',
      address: json['address'] == null
          ? null
          : PostAddressRequest.fromJson(
              json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PostUserRequestToJson(PostUserRequest instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'address': instance.address,
    };

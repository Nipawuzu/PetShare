import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/services/generics/post_address_request.dart';
import 'package:pet_share/services/generics/post_user_request.dart';

part 'post_shelter_request.g.dart';

@JsonSerializable()
class PostShelterRequest extends PostUserRequest {
  PostShelterRequest(
      {this.fullShelterName = '',
      String userName = '',
      String phoneNumber = '',
      String email = '',
      PostAddressRequest? address})
      : super(
          userName: userName,
          phoneNumber: phoneNumber,
          email: email,
          address: address,
        );

  String fullShelterName;

  @override
  Map<String, dynamic> toJson() => _$PostShelterRequestToJson(this);
  factory PostShelterRequest.fromJson(Map<String, dynamic> json) =>
      _$PostShelterRequestFromJson(json);
}

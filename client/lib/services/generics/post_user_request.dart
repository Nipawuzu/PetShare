import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/services/generics/post_address_request.dart';

part 'post_user_request.g.dart';

@JsonSerializable()
class PostUserRequest {
  PostUserRequest(
      {this.userName = '',
      this.phoneNumber = '',
      this.email = '',
      this.address});

  String userName;
  String phoneNumber;
  String email;
  PostAddressRequest? address;

  Map<String, dynamic> toJson() => _$PostUserRequestToJson(this);
  factory PostUserRequest.fromJson(Map<String, dynamic> json) =>
      _$PostUserRequestFromJson(json);
}

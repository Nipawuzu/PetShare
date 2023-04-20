import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/services/generics/post_address_request.dart';
import 'package:pet_share/services/generics/post_user_request.dart';

part 'post_adopter_request.g.dart';

@JsonSerializable()
class PostAdopterRequest extends PostUserRequest {
  PostAdopterRequest(
      {this.firstName = '',
      this.lastName = '',
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

  String firstName;
  String lastName;

  @override
  Map<String, dynamic> toJson() => _$PostAdopterRequestToJson(this);
  factory PostAdopterRequest.fromJson(Map<String, dynamic> json) =>
      _$PostAdopterRequestFromJson(json);
}

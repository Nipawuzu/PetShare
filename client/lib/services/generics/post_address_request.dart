import 'package:json_annotation/json_annotation.dart';

part 'post_address_request.g.dart';

@JsonSerializable()
class PostAddressRequest {
  PostAddressRequest(
      {this.street = '',
      this.city = '',
      this.province = '',
      this.postalCode = '',
      this.country = ''});

  String street;
  String city;
  String province;
  String postalCode;
  String country;

  Map<String, dynamic> toJson() => _$PostAddressRequestToJson(this);
  factory PostAddressRequest.fromJson(Map<String, dynamic> json) =>
      _$PostAddressRequestFromJson(json);
}

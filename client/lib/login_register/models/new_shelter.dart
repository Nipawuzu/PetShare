import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/services/generics/post_address_request.dart';

import 'new_adopter.dart';

part 'new_shelter.g.dart';

@JsonSerializable()
class NewShelter extends NewUser {
  NewShelter(
      {this.fullShelterName = '',
      String userName = '',
      String phoneNumber = '',
      String dialCode = '+48',
      String isoCode = 'PL',
      String email = '',
      NewAddress? address})
      : super(
          address: address,
          dialCode: dialCode,
          email: email,
          isoCode: isoCode,
          phoneNumber: phoneNumber,
          userName: userName,
        );

  String fullShelterName;

  @override
  Map<String, dynamic> toJson() => _$NewShelterToJson(this);
  factory NewShelter.fromJson(Map<String, dynamic> json) =>
      _$NewShelterFromJson(json);
}

@JsonSerializable()
class NewAddress {
  NewAddress(
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

  Map<String, dynamic> toJson() => _$NewAddressToJson(this);
  factory NewAddress.fromJson(Map<String, dynamic> json) =>
      _$NewAddressFromJson(json);

  PostAddressRequest toPostAddressRequest() => PostAddressRequest(
      street: street,
      city: city,
      province: province,
      postalCode: postalCode,
      country: country);
}
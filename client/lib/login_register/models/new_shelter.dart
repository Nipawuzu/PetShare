import 'package:pet_share/services/generics/post_address_request.dart';
import 'new_adopter.dart';

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
}

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

  PostAddressRequest toPostAddressRequest() => PostAddressRequest(
      street: street,
      city: city,
      province: province,
      postalCode: postalCode,
      country: country);
}

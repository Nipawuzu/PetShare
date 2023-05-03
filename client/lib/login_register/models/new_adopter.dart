import 'new_shelter.dart';

class NewUser {
  NewUser(
      {this.userName = '',
      this.phoneNumber = '',
      this.dialCode = '+48',
      this.isoCode = 'PL',
      this.email = '',
      this.address});

  String userName;
  String phoneNumber;
  String dialCode;
  String isoCode;
  String email;
  NewAddress? address;
}

class NewAdopter extends NewUser {
  NewAdopter(
      {this.firstName = '',
      this.lastName = '',
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

  String firstName;
  String lastName;
}

import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/login_register/requests/new_shelter.dart';

part 'new_adopter.g.dart';

@JsonSerializable()
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

  Map<String, dynamic> toJson() => _$NewUserToJson(this);
  factory NewUser.fromJson(Map<String, dynamic> json) =>
      _$NewUserFromJson(json);
}

@JsonSerializable()
class NewAdopter extends NewUser {
  NewAdopter({
    this.firstName = '',
    this.lastName = '',
  });

  String firstName;
  String lastName;

  @override
  Map<String, dynamic> toJson() => _$NewAdopterToJson(this);
  factory NewAdopter.fromJson(Map<String, dynamic> json) =>
      _$NewAdopterFromJson(json);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/address.dart';

part 'shelter.g.dart';

@JsonSerializable()
class User {
  User({
    required this.userName,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });

  String userName;
  String phoneNumber;
  String email;
  Address address;
}

@JsonSerializable()
class Shelter extends User {
  Shelter({
    required super.userName,
    required super.phoneNumber,
    required super.email,
    required super.address,
    required this.fullShelterName,
  });

  bool isAuthorized = false;
  String fullShelterName;
  Map<String, dynamic> toJson() => _$ShelterToJson(this);
  factory Shelter.fromJson(Map<String, dynamic> json) => _$ShelterFromJson(json);
}

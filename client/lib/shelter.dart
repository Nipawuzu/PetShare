import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/address.dart';

part 'shelter.g.dart';

@JsonSerializable()
class User {
  User({
    required this.id,
    required this.userName,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });

  String id;
  String userName;
  String phoneNumber;
  String email;
  Address address;

  Map<String, dynamic> toJson() => _$UserToJson(this);
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@JsonSerializable()
class Shelter extends User {
  Shelter({
    required super.id,
    required super.userName,
    required super.phoneNumber,
    required super.email,
    required super.address,
    required this.fullShelterName,
  });

  bool isAuthorized = false;
  String fullShelterName;

  @override
  Map<String, dynamic> toJson() => _$ShelterToJson(this);
  factory Shelter.fromJson(Map<String, dynamic> json) =>
      _$ShelterFromJson(json);
}

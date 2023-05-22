import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/address.dart';
import 'package:pet_share/shelter.dart';

part 'adopter.g.dart';

@JsonSerializable()
class Adopter extends User {
  Adopter(
      {required super.id,
      required super.userName,
      required super.phoneNumber,
      required super.email,
      required super.address,
      required this.status});

  AdopterStatusDTO status;

  @override
  Map<String, dynamic> toJson() => _$AdopterToJson(this);
  factory Adopter.fromJson(Map<String, dynamic> json) =>
      _$AdopterFromJson(json);
}

// ignore: constant_identifier_names
enum AdopterStatusDTO { Active, Blocked, Deleted }

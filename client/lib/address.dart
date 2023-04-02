import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Address {
  Address({
    required this.street,
    required this.city,
    required this.postalCode,
    required this.province,
    required this.country,
  });

  String street;
  String city;
  String postalCode;
  String province;
  String country;
}

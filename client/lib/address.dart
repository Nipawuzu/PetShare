import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

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

  Map<String, dynamic> toJson() => _$AddressToJson(this);
  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  @override
  String toString() {
    return "$country, $province\nul. $street\n$postalCode $city";
  }
}

import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/announcements/models/pet.dart';
import 'package:pet_share/utils/sex_converter.dart';
part 'post_pet_request.g.dart';

@JsonSerializable()
class PostPetRequest {
  PostPetRequest({
    this.name = "",
    this.species = "",
    this.birthday,
    this.sex = Sex.Unknown,
    this.breed = "",
    this.description = "",
  });

  String name;
  String species;
  String breed;
  @SexConverter()
  Sex sex;
  DateTime? birthday;
  String description;

  Map<String, dynamic> toJson() => _$PostPetRequestToJson(this);
  factory PostPetRequest.fromJson(Map<String, dynamic> json) =>
      _$PostPetRequestFromJson(json);
}

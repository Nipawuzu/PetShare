import 'package:json_annotation/json_annotation.dart';
part 'post_pet_request.g.dart';

@JsonSerializable()
class PostPetRequest {
  PostPetRequest({
    this.name = "",
    this.species = "",
    this.birthday,
    this.breed = "",
    this.description = "",
  });

  String name;
  String species;
  String breed;
  DateTime? birthday;
  String description;

  Map<String, dynamic> toJson() => _$PostPetRequestToJson(this);
  factory PostPetRequest.fromJson(Map<String, dynamic> json) =>
      _$PostPetRequestFromJson(json);
}

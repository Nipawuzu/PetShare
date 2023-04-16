import 'package:json_annotation/json_annotation.dart';
part 'post_pet_response.g.dart';

@JsonSerializable()
class PostPetResponse {
  PostPetResponse({
    required this.id,
  });

  String id;

  Map<String, dynamic> toJson() => _$PostPetResponseToJson(this);
  factory PostPetResponse.fromJson(Map<String, dynamic> json) =>
      _$PostPetResponseFromJson(json);
}

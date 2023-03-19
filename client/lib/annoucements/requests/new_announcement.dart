import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/annoucements/requests/new_pet.dart';

part 'new_announcement.g.dart';

@JsonSerializable()
class NewAnnouncement {
  NewAnnouncement({
    this.title = '',
    this.description = '',
    this.pet,
    this.petId,
  });

  NewPet? pet;
  String? petId;
  String title;
  String description;

  Map<String, dynamic> toJson() => _$NewAnnouncementToJson(this);
  factory NewAnnouncement.fromJson(Map<String, dynamic> json) =>
      _$NewAnnouncementFromJson(json);
}

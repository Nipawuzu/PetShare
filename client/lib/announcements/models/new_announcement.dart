import 'package:pet_share/announcements/models/new_pet.dart';

class NewAnnouncement {
  NewAnnouncement({
    this.title = '',
    this.description = '',
    this.petId,
  });

  String? petId;
  String title;
  String description;
  NewPet? pet;
}

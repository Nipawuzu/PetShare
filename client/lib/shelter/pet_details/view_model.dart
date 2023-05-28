import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/announcements/models/pet.dart';

class PetDetailsViewModel {
  final Announcement? announcement;
  final Pet pet;
  final int numberOfApplications;

  PetDetailsViewModel(
      {required this.pet,
      required this.numberOfApplications,
      required this.announcement});
}

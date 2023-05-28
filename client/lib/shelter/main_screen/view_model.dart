import 'package:pet_share/announcements/models/pet.dart';
import 'package:pet_share/applications/application.dart';

class PetListItemViewModel {
  final Pet pet;
  final List<Application> applications;
  int waitingApplicationsCount;

  PetListItemViewModel({
    required this.pet,
    required this.applications,
    this.waitingApplicationsCount = 0,
  });
}

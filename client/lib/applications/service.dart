import 'package:pet_share/address.dart';
import 'package:pet_share/announcements/announcement.dart';
import 'package:pet_share/announcements/pet.dart';
import 'package:pet_share/applications/application.dart';
import 'package:pet_share/shelter.dart';

class ApplicationService {
  ApplicationService();

  Future<List<Application>> getApplications() async {
    List<Application> result = [
      Application(
        announcement: Announcement(
          title: "Mega fajny piesek",
          status: AnnouncementStatus.open,
          pet: Pet(
            name: "Bobik",
            species: "Pies",
            birthday: DateTime(2019, 9, 14),
            breed: "Mieszaniec",
            description: "Bardzo dobry piesek",
            shelter: Shelter(
              address: Address(
                city: "Warszawa",
                country: "Polska",
                postalCode: "15-123",
                province: "Mazowieckie",
                street: "Schroniskowa 15",
              ),
              email: "schronisko@gmail.com",
              fullShelterName: "Super duper fajne schronisko",
              phoneNumber: "123456789",
              userName: "Fajne schronisko",
            ),
          ),
          description: "Ogłoszenie z fajnym pieskiem",
        ),
        user: User(
            address: Address(
              city: "Polkowice Dolne",
              country: "Polska",
              postalCode: "18-890",
              province: "Mazowieckie",
              street: "Zielona 12",
            ),
            email: "user@mail.com",
            phoneNumber: "47328973829",
            userName: "Jan Nowak"),
        dateOfApplication: DateTime(2023, 4, 3),
        lastUpdateDate: DateTime(2023, 4, 3),
      ),
    ];

    await Future.delayed(const Duration(seconds: 2));

    return result;
  }
}
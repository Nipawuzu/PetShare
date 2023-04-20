import 'package:flutter_test/flutter_test.dart';
import 'package:pet_share/login_register/models/new_shelter.dart';
import 'package:pet_share/services/shelter/service.dart';

import 'shelter_api_mock.dart';

void main() {
  group('AdopterAPI', () {
    var url = "https://petshare.com";
    var service = ShelterService(ShelterAPIMock.createShelterApiMock(url), url);

    test('Post new shelter account', () async {
      var newShelter = NewShelter(
          userName: "Test username",
          fullShelterName: "Test full shelter name",
          email: "Test email",
          phoneNumber: "Test phone number",
          address: NewAddress(
              street: "Test street",
              city: "Test city",
              province: "Test province",
              postalCode: "12-345",
              country: "Test country"));
      var res = await service.sendShelter(newShelter);
      assert(res.isNotEmpty);
    });
  });
}

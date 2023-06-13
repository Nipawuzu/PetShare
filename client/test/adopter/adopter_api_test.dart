import 'package:flutter_test/flutter_test.dart';
import 'package:pet_share/login_register/models/new_adopter.dart';
import 'package:pet_share/login_register/models/new_shelter.dart';
import 'package:pet_share/services/adopter/service.dart';

import 'adopter_api_mock.dart';

void main() {
  group('AdopterAPI', () {
    var url = "https://petshare.com";
    var service = AdopterService(AdopterAPIMock.createAdopterApiMock(url), url);

    test('Post new application', () async {
      var res = await service.sendApplication(
          "cb849fa2-1033-4d6b-7c88-08db36d6f10f",
          "cb849fa2-1033-4d6b-7c88-08db36d6f10f");
      assert(res.data);
    });

    test('Post new adopter account', () async {
      var newAdopter = NewAdopter(
        userName: "Test username",
        email: "Test email",
        firstName: "Test first name",
        lastName: "Test last name",
        phoneNumber: "Test phone number",
        address: NewAddress(
            street: "Test street",
            city: "Test city",
            province: "Test province",
            postalCode: "12-345",
            country: "Test country"),
      );
      var res = await service.sendAdopter(newAdopter);
      assert(res.data.isNotEmpty);
    });

    test('Reject application', () async {
      var res = await service
          .rejectApplication("cb849fa2-1033-4d6b-7c88-08db36d6f10f");
      assert(res.data);
    });

    test('Accept application', () async {
      var res = await service
          .acceptApplication("cb849fa2-1033-4d6b-7c88-08db36d6f10f");
      assert(res.data);
    });
  });
}

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:pet_share/announcements/new_announcement.dart';
import 'package:pet_share/announcements/new_pet.dart';
import 'package:pet_share/announcements/service.dart';

import 'announcements_api_mock.dart';

void main() {
  group('AnnouncementsAPI', () {
    var url = "https://petshare.com";
    var service = AnnouncementService(
        APIMocksProvider.createAnnouncementsApiMock(url), url);

    test('Post new pet', () async {
      var newPet = NewPet(
          birthday: DateTime.now(),
          name: "Test name",
          breed: "Test breed",
          description: "Test description",
          species: "Test species");

      var res = await service.sendPet(newPet);
      assert(res.isNotEmpty);
    });

    test('Post new announcement', () async {
      var newAnnouncement = NewAnnouncement(
        description: "Test description",
        title: "Test title",
        petId: "cb849fa2-1033-4d6b-7c88-08db36d6f10f",
      );

      var res = await service.sendAnnouncement(newAnnouncement);
      assert(res.isNotEmpty);
    });

    test('Upload new photo for pet', () async {
      var res = await service.uploadPetPhoto(
          "cb849fa2-1033-4d6b-7c88-08db36d6f10f", Uint8List(0));
      assert(res);
    });

    test('Get announcements', () async {
      var res = await service.getAnnouncements();
      assert(res.isNotEmpty);
    });
  });
}

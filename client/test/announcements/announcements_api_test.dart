import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/announcements/models/new_announcement.dart';
import 'package:pet_share/announcements/models/new_pet.dart';
import 'package:pet_share/announcements/models/pet.dart';
import 'package:pet_share/services/announcements/service.dart';

import 'announcements_api_mock.dart';

void main() {
  group('AnnouncementsAPI', () {
    var url = "https://petshare.com";
    var service = AnnouncementService(
        AnnouncementsAPIMock.createAnnouncementsApiMock(url), url);

    test('Post new pet', () async {
      var newPet = NewPet(
          birthday: DateTime.now(),
          name: "Test name",
          breed: "Test breed",
          sex: Sex.Female,
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

    test('Update status', () async {
      var res = await service.updateStatus(
          "cb849fa2-1033-4d6b-7c88-08db36d6f10f", AnnouncementStatus.Deleted);
      assert(res);
    });
  });
}

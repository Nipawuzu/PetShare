import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_status_code/http_status_code.dart';
import 'package:pet_share/address.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/announcements/models/pet.dart';
import 'package:pet_share/shelter.dart';

extension AnnouncementsAPIMock on Dio {
  static Dio createAnnouncementsApiMock(String url) {
    Dio dio = Dio();
    final dioAdapter = DioAdapter(dio: dio);

    dioAdapter.onGet("$url/announcements", (request) {
      var res = Announcement(
              pet: Pet(
                shelter: Shelter(
                  id: "ca89146a-a3b1-4b9f-8abe-1834f764ea90",
                  email: "email",
                  fullShelterName: "fullShelterName",
                  phoneNumber: "phoneNumber",
                  userName: "userName",
                  address: Address(
                      street: "street",
                      city: "city",
                      postalCode: "postalCode",
                      province: "province",
                      country: "country"),
                ),
                birthday: DateTime.now(),
                breed: "breed",
                sex: Sex.Male,
                description: "description",
                name: "name",
                species: "species",
              ),
              status: AnnouncementStatus.Open,
              title: "title",
              description: "description")
          .toJson();

      request.reply(StatusCode.OK, [res, res, res]);
    }, data: Matchers.any);

    dioAdapter.onPost("$url/pet", (request) {
      request.reply(
        StatusCode.CREATED,
        null,
        headers: const {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          "location": ["cb849fa2-1033-4d6b-7c88-08db36d6f10f"]
        },
      );
    }, data: Matchers.any);

    dioAdapter.onPost("$url/announcements", (request) {
      request.reply(
        StatusCode.CREATED,
        null,
        headers: const {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          "location": ["cb849fa2-1033-4d6b-7c88-08db36d6f10f"]
        },
      );
    }, data: Matchers.any);

    dioAdapter.onPost("$url/pet/cb849fa2-1033-4d6b-7c88-08db36d6f10f/photo",
        (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onPut("$url/announcements/cb849fa2-1033-4d6b-7c88-08db36d6f10f",
        (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter
        .onPut("$url/announcements/cb849fa2-1033-4d6b-7c88-08db36d6f10f/like",
            (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);
    return dio;
  }
}

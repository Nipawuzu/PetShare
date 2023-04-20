import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_status_code/http_status_code.dart';
import 'package:pet_share/address.dart';
import 'package:pet_share/announcements/announcement.dart';
import 'package:pet_share/announcements/pet.dart';
import 'package:pet_share/services/announcements/responses/post_pet_response.dart';
import 'package:pet_share/shelter.dart';

class APIMocksProvider {
  static Dio createAnnouncementsApiMock(String url) {
    Dio dio = Dio();
    final dioAdapter = DioAdapter(dio: dio);

    dioAdapter.onGet("$url/announcements", (request) {
      var res = Announcement(
              pet: Pet(
                shelter: Shelter(
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
                description: "description",
                name: "name",
                species: "species",
              ),
              status: AnnouncementStatus.open,
              title: "title",
              description: "description")
          .toJson();

      request.reply(StatusCode.OK, [res, res, res]);
    }, data: Matchers.any);

    dioAdapter.onPost("$url/pet", (request) {
      var res = PostPetResponse(id: "cb849fa2-1033-4d6b-7c88-08db36d6f10f");
      request.reply(StatusCode.OK, res.toJson());
    }, data: Matchers.any);

    dioAdapter.onPost("$url/announcements", (request) {
      var res = PostPetResponse(id: "cb849fa2-1033-4d6b-7c88-08db36d6f10f");
      request.reply(StatusCode.OK, res.toJson());
    }, data: Matchers.any);

    dioAdapter.onPost("$url/pet/cb849fa2-1033-4d6b-7c88-08db36d6f10f/photo",
        (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    return dio;
  }
}

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_status_code/http_status_code.dart';
import 'package:pet_share/address.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/announcements/models/new_announcement.dart';
import 'package:pet_share/announcements/models/new_pet.dart';
import 'package:pet_share/announcements/models/pet.dart';
import 'package:pet_share/services/announcements/requests/post_announcement_request.dart';
import 'package:pet_share/services/announcements/requests/post_pet_request.dart';
import 'package:pet_share/services/announcements/requests/put_announcement_like_request.dart';
import 'package:pet_share/services/service_response.dart';
import 'package:pet_share/shelter.dart';

import 'requests/put_announcement_request.dart';

class AnnouncementService {
  AnnouncementService(this._dio, this._url);

  final Dio _dio;
  final String _url;
  String _token = "Bearer ";

  void setToken(String token) {
    _token = "Bearer $token";
  }

  Future<ServiceResponse<String>> sendPet(NewPet pet) async {
    try {
      var response = await _dio.post(
        "$_url/pet",
        data: PostPetRequest(
                name: pet.name,
                birthday: pet.birthday,
                breed: pet.breed,
                description: pet.description,
                species: pet.species,
                sex: pet.sex)
            .toJson(),
        options: Options(headers: {
          "Authorization": _token,
          "HttpHeaders.contentTypeHeader": "application/json",
        }),
      );

      var id = response.headers.value("location");
      return response.statusCode == StatusCode.CREATED && id != null
          ? ServiceResponse(data: id)
          : ServiceResponse(data: "", error: ErrorType.unknown);
    } on DioError catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return ServiceResponse(data: "", error: ErrorType.unauthorized);
      }

      return ServiceResponse(data: "", error: ErrorType.unknown);
    }
  }

  Future<ServiceResponse<bool>> uploadPetPhoto(
      String petId, Uint8List photo) async {
    try {
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(photo, filename: petId),
      });

      var response = await _dio.post(
        "$_url/pet/$petId/photo",
        data: formData,
        options: Options(headers: {
          "Authorization": _token,
        }),
      );

      return ServiceResponse(data: response.statusCode == StatusCode.OK);
    } on DioError catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return ServiceResponse(data: false, error: ErrorType.unauthorized);
      }

      return ServiceResponse(data: false, error: ErrorType.unknown);
    }
  }

  Future<ServiceResponse<String>> sendAnnouncement(
      NewAnnouncement announcement) async {
    try {
      var response = await _dio.post(
        "$_url/announcements",
        data: PostAnnouncementRequest(
          title: announcement.title,
          description: announcement.description,
          petId: announcement.petId,
        ).toJson(),
        options: Options(headers: {
          "Authorization": _token,
          "HttpHeaders.contentTypeHeader": "application/json",
        }),
      );

      var id = response.headers.value("location");
      return response.statusCode == StatusCode.CREATED && id != null
          ? ServiceResponse(data: id)
          : ServiceResponse(data: "", error: ErrorType.unknown);
    } on DioError catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return ServiceResponse(data: "", error: ErrorType.unauthorized);
      } else if (e.response?.statusCode == StatusCode.BAD_REQUEST) {
        return ServiceResponse(data: "", error: ErrorType.badRequest);
      }

      return ServiceResponse(data: "", error: ErrorType.unknown);
    }
  }

  Future<ServiceResponse<List<Announcement>?>> getAnnouncements() async {
    try {
      var response = await _dio.get(
        "$_url/announcements",
        options: Options(headers: {
          "HttpHeaders.contentTypeHeader": "application/json",
          "Authorization": _token
        }),
      );

      if (response.statusCode == StatusCode.OK) {
        return ServiceResponse(
            data: (response.data as List)
                .map((e) => Announcement.fromJson(e))
                .toList());
      } else {
        return ServiceResponse(data: [], error: ErrorType.unknown);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return ServiceResponse(data: null, error: ErrorType.unauthorized);
      }

      return ServiceResponse(data: null, error: ErrorType.unknown);
    }
  }

  Future<List<Announcement>> getObservedAnnouncements() async {
    // TODO: delete the mock implementation
    return Future.delayed(
      const Duration(seconds: 2),
      () => [
        Announcement(
            pet: Pet(
                shelter: Shelter(
                  id: "ca89146a-a3b1-4b9f-8abe-1834f764ea90",
                  address: Address(
                    city: "Warszawa",
                    country: "Polska",
                    postalCode: "12-123",
                    province: "Mazowieckie",
                    street: "Marszałkowska",
                  ),
                  email: "shelter@mail.com",
                  fullShelterName: "Pelna nazwa schroniska",
                  phoneNumber: "123456789",
                  userName: "Wlasciciel schroniska",
                ),
                birthday: DateTime(2020, 05, 10),
                species: "Pies",
                breed: "Mieszaniec",
                description: "Bardzo fajny piesek do przygarniecia",
                name: "Ares",
                photoUrl: null,
                sex: Sex.Male),
            title: "Ares do adopcji",
            description: "Fajny piesek Ares szuka domu"),
      ],
    );
  }

  Future<ServiceResponse<bool>> updateStatus(
      String? announcementId, AnnouncementStatus newStatus) async {
    try {
      var announcement = PutAnnouncementRequest(
        status: newStatus,
        petId: null,
        title: null,
        description: null,
      );

      var response = await _dio.put(
        "$_url/announcements/$announcementId",
        data: announcement.toJson(),
        options: Options(headers: {
          "Authorization": _token,
          "HttpHeaders.contentTypeHeader": "application/json",
        }),
      );

      return ServiceResponse(data: response.statusCode == StatusCode.OK);
    } on DioError catch (e) {
      {
        if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
          return ServiceResponse(data: false, error: ErrorType.unauthorized);
        } else if (e.response?.statusCode == StatusCode.BAD_REQUEST) {
          return ServiceResponse(data: false, error: ErrorType.badRequest);
        }

        return ServiceResponse(data: false, error: ErrorType.unknown);
      }
    }
  }

  Future<void> likeAnnouncement(String announcementId, bool isLiked) async {
    var announcementLiked = PutAnnouncementLikeRequest(
        announcementId: announcementId, isLiked: isLiked);
    await _dio.put(
      "$_url/announcements/like",
      data: announcementLiked.toJson(),
      options: Options(headers: {
        "Authorization": _token,
        "HttpHeaders.contentTypeHeader": "application/json",
      }),
    );
  }

  Future<void> likeAnnouncement(String announcementId, bool isLiked) async {
    var announcementLiked = PutAnnouncementLikeRequest(
        announcementId: announcementId, isLiked: isLiked);
    await _dio.put(
      "$_url/announcements/like",
      data: announcementLiked.toJson(),
      options: Options(headers: {
        "Authorization": _token,
        "HttpHeaders.contentTypeHeader": "application/json",
      }),
    );
  }
}

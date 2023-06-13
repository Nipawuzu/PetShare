import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_status_code/http_status_code.dart';
import 'package:pet_share/adopter/main_screen/announcement_filters.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/announcements/models/new_announcement.dart';
import 'package:pet_share/announcements/models/new_pet.dart';
import 'package:pet_share/announcements/models/pet.dart';
import 'package:pet_share/services/announcements/requests/post_announcement_request.dart';
import 'package:pet_share/services/announcements/requests/post_pet_request.dart';
import 'package:pet_share/services/announcements/responses/get_announcements_response.dart';
import 'package:pet_share/services/service_response.dart';

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

  Future<ServiceResponse<Pet?>> getPetById(String petId) async {
    try {
      var response = await _dio.get(
        "$_url/pet/$petId",
        options: Options(headers: {
          "Authorization": _token,
          "HttpHeaders.contentTypeHeader": "application/json",
        }),
      );

      if (response.statusCode == StatusCode.OK) {
        return ServiceResponse(data: Pet.fromJson(response.data));
      } else {
        return ServiceResponse(data: null, error: ErrorType.unknown);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return ServiceResponse(data: null, error: ErrorType.unauthorized);
      } else if (e.response?.statusCode == StatusCode.NOT_FOUND) {
        return ServiceResponse(data: null, error: ErrorType.notFound);
      }

      return ServiceResponse(data: null, error: ErrorType.unknown);
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

  Future<ServiceResponse<List<Announcement>?>> getAnnouncements(
      {int pageNumber = 0,
      int pageCount = 10,
      AnnouncementFilters? filters}) async {
    try {
      var response = await _dio.get("$_url/announcements",
          options: Options(
            headers: {
              "HttpHeaders.contentTypeHeader": "application/json",
              "Authorization": _token
            },
          ),
          queryParameters: createQueryParametersForFilters(
            pageNumber,
            pageCount,
            filters,
          ));

      if (response.statusCode == StatusCode.OK) {
        return ServiceResponse(
            data:
                GetAnnouncementsResponse.fromJson(response.data).announcements);
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

  Map<String, dynamic> createQueryParametersForFilters(
      int pageNumber, int pageCount, AnnouncementFilters? filters) {
    var map = {
      "pageNumber": pageNumber,
      "pageCount": pageCount,
      "species": filters?.species,
      "breeds": filters?.breeds,
      "locations": filters?.cities,
      "shelterNames": filters?.shelters,
    };

    if (filters != null && filters.minAge != null) {
      map["minAge"] = filters.minAge;
    }
    if (filters != null && filters.maxAge != null) {
      map["maxAge"] = filters.maxAge;
    }

    return map;
  }

  Future<ServiceResponse<List<Announcement>?>>
      getObservedAnnouncements() async {
    try {
      var response = await _dio.get(
        "$_url/announcements",
        queryParameters: {
          "isLiked": true,
        },
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

  Future<ErrorType> likeAnnouncement(
      String announcementId, bool isLiked) async {
    try {
      await _dio.put(
        "$_url/announcements/$announcementId/like",
        queryParameters: {
          "isLiked": isLiked,
        },
        options: Options(headers: {
          "Authorization": _token,
          "HttpHeaders.contentTypeHeader": "application/json",
        }),
      );
      return ErrorType.none;
    } on DioError catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return ErrorType.unauthorized;
      } else if (e.response?.statusCode == StatusCode.BAD_REQUEST) {
        return ErrorType.badRequest;
      } else if (e.response?.statusCode == StatusCode.NOT_FOUND) {
        return ErrorType.notFound;
      } else if (e.response?.statusCode == StatusCode.FORBIDDEN) {
        return ErrorType.forbidden;
      }

      return ErrorType.unknown;
    }
  }
}

import 'package:dio/dio.dart';
import 'package:http_status_code/http_status_code.dart';
import 'package:pet_share/applications/application.dart';
import 'package:pet_share/login_register/models/new_adopter.dart';
import 'package:pet_share/services/adopter/requests/post_adopter_request.dart';
import 'package:pet_share/services/adopter/requests/post_application_request.dart';
import 'package:pet_share/services/adopter/responses/get_applications_reponse.dart';
import 'package:pet_share/services/service_response.dart';

class AdopterService {
  AdopterService(this._dio, this._url);

  final Dio _dio;
  final String _url;
  String _token = "Bearer ";

  void setToken(String token) {
    _token = "Bearer $token";
  }

  Future<ServiceResponse<String>> sendAdopter(NewAdopter adopter) async {
    try {
      var response = await _dio.post(
        "$_url/adopter",
        data: PostAdopterRequest(
                lastName: adopter.lastName,
                firstName: adopter.firstName,
                userName: adopter.userName,
                email: adopter.email,
                phoneNumber: adopter.dialCode + adopter.phoneNumber,
                address: adopter.address?.toPostAddressRequest())
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

  Future<ServiceResponse<bool>> sendApplication(
      String adopterId, String announcementId) async {
    try {
      var response = await _dio.post(
        "$_url/applications",
        data: PostApplicationRequest(
                adopterId: adopterId, announcementId: announcementId)
            .toJson(),
        options: Options(headers: {
          "Authorization": _token,
          "HttpHeaders.contentTypeHeader": "application/json",
        }),
      );

      var id = response.headers.value("location");
      return ServiceResponse(
          data: response.statusCode == StatusCode.CREATED && id != null);
    } on DioError catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return ServiceResponse(data: false, error: ErrorType.unauthorized);
      }

      return ServiceResponse(data: false, error: ErrorType.unknown);
    }
  }

  Future<ServiceResponse<List<Application>?>> getApplications(
      {int pageNumber = 0, int pageCount = 10}) async {
    try {
      var response = await _dio.get("$_url/applications",
          options: Options(
            headers: {
              "Authorization": _token,
              "HttpHeaders.contentTypeHeader": "application/json",
            },
          ),
          queryParameters: {
            "pageNumber": pageNumber,
            "pageCount": pageCount,
          });

      if (response.statusCode == StatusCode.OK) {
        return ServiceResponse(
            data: GetApplicationsResponse.fromJson(response.data).applications);
      } else {
        return ServiceResponse(data: [], error: ErrorType.unknown);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return ServiceResponse(data: null, error: ErrorType.unauthorized);
      } else if (e.response?.statusCode == StatusCode.BAD_REQUEST) {
        return ServiceResponse(data: null, error: ErrorType.badRequest);
      }
    }

    return ServiceResponse(data: null, error: ErrorType.unknown);
  }

  Future<ServiceResponse<List<Application>?>> getApplicationsForAnnouncement(
      String announcementId,
      {int pageNumber = 0,
      int pageCount = 10}) async {
    try {
      var response = await _dio.get("$_url/applications/$announcementId",
          options: Options(
            headers: {
              "Authorization": _token,
              "HttpHeaders.contentTypeHeader": "application/json",
            },
          ),
          queryParameters: {
            "pageNumber": pageNumber,
            "pageCount": pageCount,
          });

      if (response.statusCode == StatusCode.OK) {
        return ServiceResponse(
            data: GetApplicationsResponse.fromJson(response.data).applications);
      } else {
        return ServiceResponse(data: null, error: ErrorType.unknown);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return ServiceResponse(data: null, error: ErrorType.unauthorized);
      } else if (e.response?.statusCode == StatusCode.BAD_REQUEST) {
        return ServiceResponse(data: null, error: ErrorType.badRequest);
      }
    }

    return ServiceResponse(data: null, error: ErrorType.unknown);
  }

  Future<ServiceResponse<bool>> rejectApplication(String applicationId) async {
    try {
      var response = await _dio.put(
        "$_url/applications/$applicationId/reject",
        options: Options(
          headers: {
            "Authorization": _token,
            "HttpHeaders.contentTypeHeader": "application/json",
          },
        ),
      );

      if (response.statusCode == StatusCode.OK) {
        return ServiceResponse(data: true);
      } else {
        return ServiceResponse(data: false, error: ErrorType.unknown);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return ServiceResponse(data: false, error: ErrorType.unauthorized);
      } else if (e.response?.statusCode == StatusCode.BAD_REQUEST) {
        return ServiceResponse(data: false, error: ErrorType.badRequest);
      }
    }

    return ServiceResponse(data: false, error: ErrorType.unknown);
  }

  Future<ServiceResponse<bool>> acceptApplication(String applicationId) async {
    try {
      var response = await _dio.put(
        "$_url/applications/$applicationId/accept",
        options: Options(
          headers: {
            "Authorization": _token,
            "HttpHeaders.contentTypeHeader": "application/json",
          },
        ),
      );

      if (response.statusCode == StatusCode.OK) {
        return ServiceResponse(data: true);
      } else {
        return ServiceResponse(data: false, error: ErrorType.unknown);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return ServiceResponse(data: false, error: ErrorType.unauthorized);
      } else if (e.response?.statusCode == StatusCode.BAD_REQUEST) {
        return ServiceResponse(data: false, error: ErrorType.badRequest);
      }
    }

    return ServiceResponse(data: false, error: ErrorType.unknown);
  }
}
import 'package:dio/dio.dart';
import 'package:http_status_code/http_status_code.dart';
import 'package:pet_share/applications/application.dart';
import 'package:pet_share/login_register/models/new_adopter.dart';
import 'package:pet_share/services/adopter/requests/post_adopter_request.dart';
import 'package:pet_share/services/adopter/requests/post_application_request.dart';
import 'package:pet_share/services/error_type.dart';

class AdopterService {
  AdopterService(this._dio, this._url);

  final Dio _dio;
  final String _url;
  String _token = "Bearer ";
  ErrorType lastError = ErrorType.none;

  void setToken(String token) {
    _token = "Bearer $token";
  }

  Future<String> sendAdopter(NewAdopter adopter) async {
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
      return response.statusCode == StatusCode.CREATED && id != null ? id : "";
    } on DioError catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        lastError = ErrorType.unauthorized;
        return "";
      }

      lastError = ErrorType.unknown;
      return "";
    }
  }

  Future<bool> sendApplication(String adopterId, String announcementId) async {
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
      return response.statusCode == StatusCode.CREATED && id != null;
    } on DioError catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        lastError = ErrorType.unauthorized;
        return false;
      }

      lastError = ErrorType.unknown;
      return false;
    }
  }

  Future<List<Application>?> getApplications() async {
    try {
      var response = await _dio.get(
        "$_url/applications",
        options: Options(headers: {
          "Authorization": _token,
          "HttpHeaders.contentTypeHeader": "application/json",
        }),
      );

      if (response.statusCode == StatusCode.OK) {
        return (response.data as List)
            .map((e) => Application.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        lastError = ErrorType.unauthorized;
        return null;
      } else if (e.response?.statusCode == StatusCode.BAD_REQUEST) {
        lastError = ErrorType.badRequest;
        return null;
      }
    }

    lastError = ErrorType.unknown;
    return null;
  }
}

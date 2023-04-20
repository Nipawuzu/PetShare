import 'package:dio/dio.dart';
import 'package:http_status_code/http_status_code.dart';
import 'package:pet_share/login_register/models/new_adopter.dart';
import 'package:pet_share/services/adopter/requests/post_adopter_request.dart';
import 'package:pet_share/services/adopter/requests/post_application_request.dart';

class AdopterService {
  AdopterService(this._dio, this._url);

  final Dio _dio;
  final String _url;
  final String _token = "Bearer ";

  Future<String> sendAdopter(NewAdopter adopter) async {
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
  }

  Future<bool> sendApplication(String adopterId, String announcementId) async {
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
  }
}

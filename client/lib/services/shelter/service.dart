import 'package:dio/dio.dart';
import 'package:http_status_code/http_status_code.dart';
import 'package:pet_share/login_register/models/new_shelter.dart';
import 'package:pet_share/services/error_type.dart';
import 'package:pet_share/services/shelter/requests/post_shelter_request.dart';

class ShelterService {
  ShelterService(this._dio, this._url);

  final Dio _dio;
  final String _url;
  String _token = "Bearer ";
  ErrorType lastError = ErrorType.none;

  void setToken(String token) {
    _token = "Bearer $token";
  }

  Future<String> sendShelter(NewShelter shelter) async {
    try {
      var response = await _dio.post(
        "$_url/shelter",
        data: PostShelterRequest(
                userName: shelter.userName,
                fullShelterName: shelter.fullShelterName,
                email: shelter.email,
                phoneNumber: shelter.dialCode + shelter.phoneNumber,
                address: shelter.address?.toPostAddressRequest())
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
}

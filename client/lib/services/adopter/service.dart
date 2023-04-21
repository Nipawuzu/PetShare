import 'package:dio/dio.dart';
import 'package:http_status_code/http_status_code.dart';
import 'package:pet_share/login_register/new_adopter.dart';
import 'package:pet_share/services/adopter/requests/post_adopter_request.dart';

class AdopterService {
  AdopterService(this._dio, this._url);

  final Dio _dio;
  final String _url;
  String _token = "Bearer ";

  void setToken(String token) {
    _token = "Bearer $token";
  }

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
}

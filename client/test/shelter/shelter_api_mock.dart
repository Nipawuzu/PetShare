import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_status_code/http_status_code.dart';

extension ShelterAPIMock on Dio {
  static Dio createShelterApiMock(String url) {
    Dio dio = Dio();
    final dioAdapter = DioAdapter(dio: dio);

    dioAdapter.onPost("$url/shelter", (request) {
      request.reply(
        StatusCode.CREATED,
        null,
        headers: const {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          "location": ["cb849fa2-1033-4d6b-7c88-08db36d6f10f"]
        },
      );
    }, data: Matchers.any);

    return dio;
  }
}

import 'package:dio/dio.dart';
import 'package:http_status_code/http_status_code.dart';
import 'package:pet_share/announcements/requests/new_announcement.dart';

class AnnouncementService {
  AnnouncementService(this._url);

  final String _url;

  Future<bool> sendAnnouncement(NewAnnouncement announcement) async {
    var response = await Dio().post(
      "$_url/announcements",
      data: announcement.toJson(),
      options: Options(headers: {
        "Authorization": "",
        "HttpHeaders.contentTypeHeader": "application/json",
      }),
    );

    return response.statusCode == StatusCode.OK;
  }
}

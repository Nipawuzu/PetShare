import 'package:dio/dio.dart';
import 'package:http_status_code/http_status_code.dart';
import 'package:pet_share/announcements/announcement.dart';
import 'package:pet_share/announcements/requests/new_announcement.dart';
import 'package:pet_share/announcements/requests/put_announcement.dart';

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

  Future<List<Announcement>> getAnnouncements() async {
    var response = await Dio().get(
      "$_url/announcements",
      options: Options(headers: {
        "HttpHeaders.contentTypeHeader": "application/json",
        "Authorization": ""
      }),
    );

    if (response.statusCode == StatusCode.OK) {
      return (response.data as List)
          .map((e) => Announcement.fromJson(e))
          .toList();
    } else {
      return [];
    }
  }

  Future<bool> updateStatus(
      String? announcementId, AnnouncementStatus newStatus) async {
    var announcement = PutAnnouncement(
      status: newStatus,
      petId: null,
      title: null,
      description: null,
    );
    var response = await Dio().put(
      "$_url/announcements/$announcementId",
      data: announcement.toJson(),
      options: Options(headers: {
        "Authorization": "",
        "HttpHeaders.contentTypeHeader": "application/json",
      }),
    );

    return response.statusCode == StatusCode.OK;
  }
}

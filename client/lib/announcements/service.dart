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
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIzZmE4NWY2NC01NzE3LTQ1NjItYjNmYy0yYzk2M2Y2NmFmYTYiLCJleHAiOjE5MTYyMzkwMjIsImF1ZCI6WyJBQUEiXSwicm9sZXMiOlsiU2hlbHRlciJdfQ.E2872Rdzn0qvJnjXn_rJA-IHSQm4Nqu49OHlkfhUbe8",
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
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIzZmE4NWY2NC01NzE3LTQ1NjItYjNmYy0yYzk2M2Y2NmFmYTYiLCJleHAiOjE5MTYyMzkwMjIsImF1ZCI6WyJBQUEiXSwicm9sZXMiOlsiQWRtaW4iXX0.1SnWaA5brkWD2l4yG3ZWczqfvH07tTHWQs9Bmn70q4Q"
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
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIzZmE4NWY2NC01NzE3LTQ1NjItYjNmYy0yYzk2M2Y2NmFmYTYiLCJleHAiOjE5MTYyMzkwMjIsImF1ZCI6WyJBQUEiXSwicm9sZXMiOlsiQWRtaW4iXX0.1SnWaA5brkWD2l4yG3ZWczqfvH07tTHWQs9Bmn70q4Q",
        "HttpHeaders.contentTypeHeader": "application/json",
      }),
    );

    return response.statusCode == StatusCode.OK;
  }
}

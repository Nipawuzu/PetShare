import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_status_code/http_status_code.dart';
import 'package:pet_share/announcements/announcement.dart';
import 'package:pet_share/announcements/new_announcement.dart';
import 'package:pet_share/announcements/new_pet.dart';
import 'package:pet_share/services/announcements/requests/post_announcement_request.dart';
import 'package:pet_share/services/announcements/requests/post_pet_request.dart';
import 'package:pet_share/services/announcements/responses/post_pet_response.dart';

import 'requests/put_announcement.dart';
import 'responses/post_announcement_response.dart';

class AnnouncementService {
  AnnouncementService(this._dio, this._url);

  final Dio _dio;
  final String _url;
  String _token = "";

  void setToken(String token) {
    _token = "Bearer $token";
  }

  Future<String> sendPet(NewPet pet) async {
    var response = await _dio.post(
      "$_url/pet",
      data: PostPetRequest(
        name: pet.name,
        birthday: pet.birthday,
        breed: pet.breed,
        description: pet.description,
        species: pet.species,
      ).toJson(),
      options: Options(headers: {
        "Authorization": _token,
        "HttpHeaders.contentTypeHeader": "application/json",
      }),
    );

    var res = PostPetResponse.fromJson(response.data);
    return response.statusCode == StatusCode.OK ? res.id : "";
  }

  Future<bool> uploadPetPhoto(String petId, Uint8List photo) async {
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(photo, filename: petId),
    });

    var response = await _dio.post(
      "$_url/pet/$petId/photo",
      data: formData,
    );

    return response.statusCode == StatusCode.OK;
  }

  Future<String> sendAnnouncement(NewAnnouncement announcement) async {
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

    var res = PostAnnouncementResponse.fromJson(response.data);
    return response.statusCode == StatusCode.OK ? res.id : "";
  }

  Future<List<Announcement>> getAnnouncements() async {
    var response = await _dio.get(
      "$_url/announcements",
      options: Options(headers: {
        "HttpHeaders.contentTypeHeader": "application/json",
        "Authorization": _token
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
    var response = await _dio.put(
      "$_url/announcements/$announcementId",
      data: announcement.toJson(),
      options: Options(headers: {
        "Authorization": _token,
        "HttpHeaders.contentTypeHeader": "application/json",
      }),
    );

    return response.statusCode == StatusCode.OK;
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/services/announcements/service.dart';
import 'package:pet_share/services/service_response.dart';

class AnnouncementDetailsState {}

class AfterAdoptionState extends AnnouncementDetailsState {
  AfterAdoptionState(this.message, this.success);

  final String message;
  final bool success;
}

class DetailsState extends AnnouncementDetailsState {
  DetailsState({required this.announcement});
  Announcement announcement;
}

class ErrorState extends AnnouncementDetailsState {}

class AnnouncementDetailsCubit extends Cubit<AnnouncementDetailsState> {
  AnnouncementDetailsCubit(
      this._announcementService, this._adopterService, this.announcement)
      : super(DetailsState(announcement: announcement));

  final AnnouncementService _announcementService;
  final AdopterService _adopterService;
  final Announcement announcement;

  Future<ServiceResponse<bool>> deleteAnnouncement(
      Announcement announcement) async {
    var res = await _announcementService.updateStatus(
        announcement.id, announcement.status);
    if (res.data) {
      announcement.status = AnnouncementStatus.Deleted;
      return res;
    }

    return res;
  }

  Future<void> adopt(String adopterId, Announcement announcement) async {
    if (announcement.id != null &&
        (await _adopterService.sendApplication(adopterId, announcement.id!))
            .data) {
      announcement.status = AnnouncementStatus.InVerification;
      emit(AfterAdoptionState(
          "Twój wniosek adopcyjny został przekazany do weryfikacji. Dziękujemy za zaufanie!",
          true));
    } else {
      emit(AfterAdoptionState(
          "Niestety nie udało nam się wysłać twojego wniosku. Spróbuj ponownie później!",
          false));
    }
  }

  void like(String adopterId, String announcementId, bool isLiked) {}
}

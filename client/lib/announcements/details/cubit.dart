import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/services/announcements/service.dart';
import 'package:pet_share/services/error_type.dart';

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

  Future<bool> deleteAnnouncement(Announcement announcement) async {
    if (await _announcementService.updateStatus(
        announcement.id, announcement.status)) {
      announcement.status = AnnouncementStatus.Deleted;
      return true;
    }

    return false;
  }

  Future<void> adopt(String adopterId, Announcement announcement) async {
    if (announcement.id != null &&
        await _adopterService.sendApplication(adopterId, announcement.id!)) {
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

  ErrorType getLastErrorFromAnnouncementService() {
    return _announcementService.lastError;
  }

  void like(String adopterId, String announcementId, bool isLiked) {}
}

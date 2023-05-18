import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/services/announcements/service.dart';

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

class AnnouncementDetailsCubit extends Cubit<AnnouncementDetailsState> {
  AnnouncementDetailsCubit(
      this._announcementService, this._adopterService, this.announcement)
      : super(DetailsState(announcement: announcement));

  final AnnouncementService _announcementService;
  final AdopterService _adopterService;
  final Announcement announcement;

  void deleteAnnouncement(Announcement announcement) {
    announcement.status = AnnouncementStatus.Deleted;
    _announcementService.updateStatus(announcement.id, announcement.status);
  }

  Future<void> adopt(String adopterId, Announcement announcement) async {
    if (announcement.id != null &&
        await _adopterService.sendApplication(adopterId, announcement.id!)) {
      announcement.status = AnnouncementStatus.InVerification;
      _announcementService.updateStatus(announcement.id, announcement.status);
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

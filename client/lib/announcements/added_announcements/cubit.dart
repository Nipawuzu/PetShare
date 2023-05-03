import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/services/announcements/service.dart';

class ListOfAnnouncementsState {}

class GridViewState extends ListOfAnnouncementsState {}

class AfterAdoptionState extends ListOfAnnouncementsState {
  AfterAdoptionState(this.message, this.success);

  final String message;
  final bool success;
}

class AnnouncementDetailsState extends ListOfAnnouncementsState {
  AnnouncementDetailsState({required this.announcement});
  Announcement announcement;
}

class GridOfAnnouncementsCubit extends Cubit<ListOfAnnouncementsState> {
  GridOfAnnouncementsCubit(this._announcementService, this._adopterService)
      : super(GridViewState());

  final AnnouncementService _announcementService;
  final AdopterService _adopterService;

  void goBack() {
    emit(GridViewState());
  }

  void seeDetails(Announcement announcement) {
    emit(AnnouncementDetailsState(announcement: announcement));
  }

  void deleteAnnouncement(Announcement announcement) {
    announcement.status = AnnouncementStatus.removed;
    _announcementService.updateStatus(announcement.id, announcement.status);
    emit(GridViewState());
  }

  Future<void> adopt(String adopterId, Announcement announcement) async {
    if (announcement.id != null &&
        await _adopterService.sendApplication(adopterId, announcement.id!)) {
      announcement.status = AnnouncementStatus.inVerification;
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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/announcements/announcement.dart';
import 'package:pet_share/services/announcements/service.dart';

class ListOfAnnouncementsState {}

class ListViewState extends ListOfAnnouncementsState {}

class AnnouncementDetailsState extends ListOfAnnouncementsState {
  AnnouncementDetailsState({required this.announcement});
  Announcement announcement;
}

class ListOfAnnouncementsCubit extends Cubit<ListOfAnnouncementsState> {
  ListOfAnnouncementsCubit(this._service) : super(ListViewState());

  final AnnouncementService _service;
  void goBack() {
    if (state is AnnouncementDetailsState) {
      emit(ListViewState());
    }
  }

  void seeDetails(Announcement announcement) {
    emit(AnnouncementDetailsState(announcement: announcement));
  }

  void deleteAnnouncement(Announcement announcement) {
    announcement.status = AnnouncementStatus.removed;
    _service.updateStatus(announcement.id, announcement.status);
    emit(ListViewState());
  }
}

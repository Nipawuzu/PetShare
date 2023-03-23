import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/announcements/announcement.dart';

class ListOfAnnouncementsState {}

class ListViewState extends ListOfAnnouncementsState {}

class AnnouncementDetailsState extends ListOfAnnouncementsState {
  AnnouncementDetailsState({required this.announcement});
  Announcement announcement;
}

class ListOfAnnouncementsCubit extends Cubit<ListOfAnnouncementsState> {
  ListOfAnnouncementsCubit() : super(ListViewState());

  void goBack() {
    if (state is AnnouncementDetailsState) {
      emit(ListViewState());
    }
  }

  void seeDetails(Announcement announcement) {
    emit(AnnouncementDetailsState(announcement: announcement));
  }
}

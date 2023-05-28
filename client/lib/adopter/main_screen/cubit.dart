import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/common_widgets/header_data_list/cubit.dart';
import 'package:pet_share/services/announcements/service.dart';
import 'package:pet_share/services/service_response.dart';

class MainAdopterViewCubit extends HeaderDataListCubit<dynamic, Announcement> {
  List<Announcement> _announcements = [];
  final AnnouncementService _service;
  static const int _pageSize = 20;
  int _currentPage = 0;

  MainAdopterViewCubit(this._service);

  @override
  Future loadData() async {
    var response = await _service.getAnnouncements(
        pageCount: _pageSize, pageNumber: _currentPage);

    if (response.data == null || response.error != ErrorType.none) {
      emit(ErrorState(message: "Wystąpił błąd podczas ładowania ogłoszeń"));
      return;
    }

    _announcements = response.data!;
    emit(DataState(headerData: null, listData: _announcements));
  }

  @override
  Future nextPage() async {
    _currentPage++;
    var response = await _service.getAnnouncements(
        pageCount: _pageSize, pageNumber: _currentPage);

    if (response.data != null) {
      _announcements.addAll(response.data!);
      emit(DataState(headerData: null, listData: _announcements));
    }
  }

  @override
  Future reloadData() async {
    _currentPage = 0;
    await loadData();
  }

  @override
  Future useFilters() {
    return Future.delayed(const Duration(seconds: 1));
  }
}

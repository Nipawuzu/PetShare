import 'package:pet_share/adopter/main_screen/announcement_filters.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/common_widgets/header_data_list/cubit.dart';
import 'package:pet_share/services/announcements/service.dart';
import 'package:pet_share/services/service_response.dart';

class MainAdopterViewCubit extends HeaderDataListCubit<dynamic, Announcement> {
  List<Announcement> _announcements = [];
  final AnnouncementService _service;
  static const int _pageSize = 20;
  int _currentPage = 0;
  AnnouncementFilters filters = AnnouncementFilters();

  MainAdopterViewCubit(this._service);

  @override
  Future loadData() async {
    var response = await _service.getAnnouncements(
        pageCount: _pageSize, pageNumber: _currentPage, filters: filters);

    if (response.data == null || response.error != ErrorType.none) {
      emit(ErrorState(message: "Wystąpił błąd podczas ładowania ogłoszeń"));
      return;
    }

    _announcements = response.data!;
    if (filters.withoutCatsAndDogs) {
      var keepCats = filters.species.contains("kot");
      var keepDogs = filters.species.contains("pies");

      _announcements = _announcements
          .where((element) =>
              (element.pet.species.toLowerCase() != "kot" || keepCats) &&
              (element.pet.species.toLowerCase() != "pies" || keepDogs))
          .toList();
    }

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

  Future useFilters(AnnouncementFilters filters) {
    emit(LoadingState());
    this.filters = filters;
    return reloadData();
  }
}

import 'package:collection/collection.dart';
import 'package:pet_share/applications/application.dart';
import 'package:pet_share/common_widgets/header_data_list/cubit.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/services/service_response.dart';
import 'package:pet_share/shelter/main_screen/view_model.dart';

class MainShelterViewCubit
    extends HeaderDataListCubit<int, PetListItemViewModel> {
  Map<String, PetListItemViewModel> _petIdToViewModel = {};
  int _newApplicationsCount = 0;
  final AdopterService _service;
  static const int _pageSize = 20;
  int _currentPage = 0;

  MainShelterViewCubit(this._service);

  @override
  Future loadData() async {
    var response = await _service.getApplications(
        pageCount: _pageSize, pageNumber: _currentPage);

    if (response.data == null || response.error != ErrorType.none) {
      emit(ErrorState(message: "Wystąpił błąd podczas ładowania ogłoszeń"));
      return;
    }

    _petIdToViewModel = {};
    _newApplicationsCount = 0;
    _groupAndCountApplications(response.data!);
    emit(DataState(
        headerData: _newApplicationsCount,
        listData: _petIdToViewModel.values.toList()));
  }

  _groupAndCountApplications(List<Application> applications) {
    var petToApplications =
        groupBy(applications, (Application a) => a.announcement.pet);

    for (var pair in petToApplications.entries) {
      var waitingApplications = pair.value
          .where((a) => a.applicationStatus == ApplicationStatusDTO.Created)
          .length;
      _newApplicationsCount += waitingApplications;

      if (_petIdToViewModel.containsKey(pair.key.id)) {
        _petIdToViewModel[pair.key.id]!.applications.addAll(pair.value);
        _petIdToViewModel[pair.key.id]!.waitingApplicationsCount +=
            waitingApplications;
      } else {
        _petIdToViewModel[pair.key.id!] = PetListItemViewModel(
            pet: pair.key,
            applications: pair.value,
            waitingApplicationsCount: waitingApplications);
      }
    }
  }

  recountApplications() {
    _newApplicationsCount = 0;
    for (var viewModel in _petIdToViewModel.values) {
      viewModel.waitingApplicationsCount = viewModel.applications
          .where((a) => a.applicationStatus == ApplicationStatusDTO.Created)
          .length;
      _newApplicationsCount += viewModel.waitingApplicationsCount;
    }

    emit(DataState(
        headerData: _newApplicationsCount,
        listData: _petIdToViewModel.values.toList()));
  }

  @override
  Future nextPage() async {
    _currentPage++;
    var response = await _service.getApplications(
        pageCount: _pageSize, pageNumber: _currentPage);

    if (response.data != null) {
      _groupAndCountApplications(response.data!);
      emit(DataState(
          headerData: _newApplicationsCount,
          listData: _petIdToViewModel.values.toList()));
    }
  }

  @override
  Future reloadData() async {
    _currentPage = 0;
    await loadData();
  }
}

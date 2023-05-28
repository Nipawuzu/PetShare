import 'package:pet_share/announcements/models/pet.dart';
import 'package:pet_share/applications/application.dart';
import 'package:pet_share/common_widgets/header_data_list/cubit.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/services/announcements/service.dart';
import 'package:pet_share/shelter/pet_details/view_model.dart';

class PetDetailsCubit
    extends HeaderDataListCubit<PetDetailsViewModel, Application> {
  Pet pet;
  List<Application> applications;
  final AdopterService _adopterService;
  final AnnouncementService _announcementService;
  int _pageSize = 0;
  int _currentPage = 0;

  PetDetailsCubit(this._adopterService, this._announcementService,
      {required this.pet, required this.applications})
      : super(
            initialState: DataState(
                headerData: PetDetailsViewModel(
                    pet: pet,
                    numberOfApplications: applications.length,
                    announcement: applications.isNotEmpty
                        ? applications.first.announcement
                        : null),
                listData: applications));

  PetDetailsViewModel _createViewModel() {
    return PetDetailsViewModel(
        pet: pet,
        numberOfApplications: applications.length,
        announcement:
            applications.isNotEmpty ? applications.first.announcement : null);
  }

  @override
  Future loadData() async {
    _pageSize = applications.length;
    emit(DataState(headerData: _createViewModel(), listData: applications));
  }

  @override
  Future nextPage() async {
    _currentPage++;
    var response = await _adopterService.getApplicationsForAnnouncement(pet.id!,
        pageCount: _pageSize, pageNumber: _currentPage);

    if (response.data != null) {
      applications.addAll(response.data!);
      emit(DataState(headerData: _createViewModel(), listData: applications));
    }
  }

  @override
  Future reloadData() async {
    _currentPage = 0;
    _pageSize = 20;

    var petResponse = await _announcementService.getPetById(pet.id!);
    if (petResponse.data != null) {
      pet = petResponse.data!;
    }

    if (applications.isNotEmpty) {
      var applicationReponse = await _adopterService
          .getApplicationsForAnnouncement(applications.first.announcementId,
              pageCount: _pageSize, pageNumber: _currentPage);
      if (applicationReponse.data != null) {
        applications = applicationReponse.data!;
      }
    }

    emit(DataState(headerData: _createViewModel(), listData: applications));
  }

  @override
  Future useFilters() {
    return Future.delayed(const Duration(seconds: 1));
  }
}

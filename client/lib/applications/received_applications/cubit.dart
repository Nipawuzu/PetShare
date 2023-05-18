import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/applications/application.dart';
import 'package:pet_share/services/adopter/service.dart';

abstract class ApplicationsViewState {}

class LoadingListOfApplicationsState extends ApplicationsViewState {}

abstract class ListOfApplicationsState extends ApplicationsViewState {
  ListOfApplicationsState({required this.applications});

  List<Application> applications;
}

class NewestApplicationsListState extends ListOfApplicationsState {
  NewestApplicationsListState({required List<Application> applications})
      : super(
          applications: applications
            ..sort(
              (a, b) => a.creationDate.compareTo(b.creationDate),
            ),
        );
}

class LastlyUpdatedApplicationsListState extends ListOfApplicationsState {
  LastlyUpdatedApplicationsListState({required List<Application> applications})
      : super(
          applications: applications
            ..sort(
              (a, b) => a.lastUpdateDate.compareTo(b.lastUpdateDate),
            ),
        );
}

class ListOfApplicationsCubit extends Cubit<ApplicationsViewState> {
  ListOfApplicationsCubit(this._service)
      : super(LoadingListOfApplicationsState()) {
    refreshApplications();
  }

  final AdopterService _service;

  Future<void> refreshApplications() async {
    var previousStateType = state.runtimeType;
    var applications = await _service.getApplications();

    if (previousStateType == LastlyUpdatedApplicationsListState) {
      emit(LastlyUpdatedApplicationsListState(applications: applications));
    } else {
      emit(NewestApplicationsListState(applications: applications));
    }
  }

  void changeToNewlyAddedApplications() {
    if (state is LastlyUpdatedApplicationsListState) {
      var st = state as LastlyUpdatedApplicationsListState;
      emit(NewestApplicationsListState(applications: st.applications));
    }
  }

  void changeToRecentlyUpdatedApplications() {
    if (state is NewestApplicationsListState) {
      var st = state as NewestApplicationsListState;
      emit(LastlyUpdatedApplicationsListState(applications: st.applications));
    }
  }
}

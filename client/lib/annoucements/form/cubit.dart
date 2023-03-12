import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/annoucements/announcement.dart';
import 'package:pet_share/annoucements/pet.dart';

class AnnouncementFormState {}

class FormClosedState extends AnnouncementFormState {}

class PetFormState extends AnnouncementFormState {
  PetFormState({this.pet});
  Pet? pet;
}

class DetailsFormState extends AnnouncementFormState {
  DetailsFormState({this.pet});
  Pet? pet;
}

class SendingFormState extends AnnouncementFormState {}

class FormSentState extends AnnouncementFormState {}

class AnnoucementFormCubit extends Cubit<AnnouncementFormState> {
  AnnoucementFormCubit() : super(PetFormState());

  List<Pet> getPets() {
    return [];
  }

  void goBack() {
    if (state is DetailsFormState) {
      emit(PetFormState(pet: (state as DetailsFormState).pet));
    }
  }

  void choosePet(Pet pet) {
    emit(DetailsFormState(pet: pet));
  }

  void submit(Announcement announcement) {
    emit(SendingFormState());
  }
}

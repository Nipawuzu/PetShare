import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/annoucements/pet.dart';
import 'package:pet_share/annoucements/requests/new_announcement.dart';
import 'package:pet_share/annoucements/requests/new_pet.dart';
import 'package:pet_share/annoucements/service.dart';

class AnnouncementFormState {}

class FormClosedState extends AnnouncementFormState {}

class PetFormState extends AnnouncementFormState {
  PetFormState({required this.announcement});
  NewAnnouncement announcement;
}

class DetailsFormState extends AnnouncementFormState {
  DetailsFormState({required this.announcement});
  NewAnnouncement announcement;
}

class SendingFormState extends AnnouncementFormState {}

class FormSentState extends AnnouncementFormState {}

class AnnouncementFormCubit extends Cubit<AnnouncementFormState> {
  AnnouncementFormCubit(this._service)
      : super(PetFormState(announcement: NewAnnouncement()));

  final AnnouncementService _service;

  List<Pet> getPets() {
    return [];
  }

  void goBack() {
    if (state is DetailsFormState) {
      emit(
          PetFormState(announcement: (state as DetailsFormState).announcement));
    }
  }

  void createPet(NewAnnouncement announcement) {
    emit(DetailsFormState(announcement: announcement));
  }

  void choosePet(NewAnnouncement announcement, Pet pet) {
    announcement.petId = pet.Id;
    announcement.pet = NewPet(
      birthday: pet.birthday,
      breed: pet.breed,
      description: pet.description,
      name: pet.name,
      photo: pet.photo,
      species: pet.species,
    );
    emit(DetailsFormState(announcement: announcement));
  }

  void submit(NewAnnouncement announcement) {
    _service
        .sendAnnouncement(announcement)
        .whenComplete(() => emit(FormSentState()));
    emit(SendingFormState());
  }
}

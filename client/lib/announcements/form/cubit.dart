import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/announcements/models/new_announcement.dart';
import 'package:pet_share/announcements/models/new_pet.dart';
import 'package:pet_share/announcements/models/pet.dart';
import 'package:pet_share/services/announcements/service.dart';

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

class FormErrorState extends AnnouncementFormState {}

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
    announcement.petId = pet.id;
    announcement.pet = NewPet(
      birthday: pet.birthday,
      breed: pet.breed,
      description: pet.description,
      name: pet.name,
      species: pet.species,
    );
    emit(DetailsFormState(announcement: announcement));
  }

  void submit(NewAnnouncement announcement) async {
    emit(SendingFormState());

    try {
      var petId = await _service.sendPet(announcement.pet!);
      if (petId.data.isEmpty) {
        emit(FormErrorState());
        return;
      }
      announcement.petId = petId.data;
      if (announcement.pet!.photo != null) {
        var response =
            await _service.uploadPetPhoto(petId.data, announcement.pet!.photo!);
        if (!response.data) {
          emit(FormErrorState());
          return;
        }
      }
      var id = await _service.sendAnnouncement(announcement);
      if (id.data.isNotEmpty) {
        emit(FormSentState());
      } else {
        emit(FormErrorState());
      }
    } catch (e) {
      emit(FormErrorState());
    }
  }
}

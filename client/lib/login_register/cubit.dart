import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/login_register/models/new_adopter.dart';
import 'package:pet_share/login_register/models/new_shelter.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/services/shelter/service.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.adopterService, required this.shelterService})
      : super(
          const SignedInState(),
        );

  int pageNumber = 0;
  AdopterService adopterService;
  ShelterService shelterService;

  Future<void> signInOrSignUp() async {
    emit(const SigningInState());
  }

  Future<void> signOut() async {
    emit(const SignedOutState());
  }

  Future<void> goBack() async {
    emit(const SignedOutState());
  }

  Future<void> goBackToChooseRegisterType() async {
    emit(ChooseRegisterTypeState(pageNumber: pageNumber));
  }

  Future<void> goBackToUserInformationPage(
      RegisterType type, NewUser user) async {
    switch (type) {
      case RegisterType.adopter:
        if (user is NewAdopter) {
          emit(RegisterAsAdopterState(adopter: user));
        }
        break;
      case RegisterType.shelter:
        if (user is NewShelter) {
          emit(RegisterAsShelterState(shelter: user));
        }
        break;
      case RegisterType.none:
        emit(ChooseRegisterTypeState(pageNumber: pageNumber));
        break;
    }
  }

  Future<void> goToAddressPage(RegisterType type, NewUser user) async {
    emit(AddressPageState(type: type, user: user));
  }

  Future<void> tryToSignUp(RegisterType type, int pageNumber) async {
    switch (type) {
      case RegisterType.adopter:
        emit(RegisterAsAdopterState(adopter: NewAdopter()));
        break;
      case RegisterType.shelter:
        emit(RegisterAsShelterState(shelter: NewShelter()));
        break;
      case RegisterType.none:
        break;
    }
    this.pageNumber = pageNumber;
  }

  Future<void> signUp(NewUser user) async {
    emit(const SigningInState());

    if (user is NewAdopter) {
      var id = await adopterService.sendAdopter(user);
      if (id.isNotEmpty) {
        emit(const SignedInState());
        return;
      }
    } else if (user is NewShelter) {
      var id = await shelterService.sendShelter(user);
      if (id.isNotEmpty) {
        emit(const SignedInState());
        return;
      }
    }

    emit(const ErrorState(
        error: "Coś poszło nie tak. Spróbuj ponownie później"));
  }
}

abstract class AuthState {
  const AuthState();
}

class SignedInState extends AuthState {
  const SignedInState();
}

class SignedOutState extends AuthState {
  const SignedOutState();
}

class ChooseRegisterTypeState extends AuthState {
  const ChooseRegisterTypeState({required this.pageNumber});

  final int pageNumber;
}

class RegisterAsAdopterState extends AuthState {
  const RegisterAsAdopterState({error, required this.adopter});
  final NewAdopter adopter;
}

class RegisterAsShelterState extends AuthState {
  const RegisterAsShelterState({error, required this.shelter});
  final NewShelter shelter;
}

class AddressPageState extends AuthState {
  const AddressPageState({error, required this.type, required this.user});
  final RegisterType type;
  final NewUser user;
}

class SigningInState extends AuthState {
  const SigningInState();
}

class ErrorState extends AuthState {
  const ErrorState({required this.error});

  final String error;
}

enum RegisterType {
  adopter,
  shelter,
  none,
}

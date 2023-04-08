import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/login_register/requests/new_adopter.dart';
import 'package:pet_share/login_register/requests/new_shelter.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit()
      : super(
          const ChooseRegisterTypeState(pageNumber: 0),
        );

  int pageNumber = 0;

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
    emit(const SignedInState());
  }
}

abstract class AuthState {
  const AuthState(this.error);

  final String? error;
}

class SignedInState extends AuthState {
  const SignedInState() : super('');
}

class SignedOutState extends AuthState {
  const SignedOutState({error}) : super(error);
}

class ChooseRegisterTypeState extends AuthState {
  const ChooseRegisterTypeState({error, required this.pageNumber})
      : super(error);

  final int pageNumber;
}

class RegisterAsAdopterState extends AuthState {
  const RegisterAsAdopterState({error, required this.adopter}) : super(error);
  final NewAdopter adopter;
}

class RegisterAsShelterState extends AuthState {
  const RegisterAsShelterState({error, required this.shelter}) : super(error);
  final NewShelter shelter;
}

class AddressPageState extends AuthState {
  const AddressPageState({error, required this.type, required this.user})
      : super(error);
  final RegisterType type;
  final NewUser user;
}

class SigningInState extends AuthState {
  const SigningInState() : super('');
}

enum RegisterType {
  adopter,
  shelter,
  none,
}

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/login_register/models/new_adopter.dart';
import 'package:pet_share/login_register/models/new_shelter.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/services/announcements/service.dart';
import 'package:pet_share/services/service_response.dart';
import 'package:pet_share/services/shelter/service.dart';
import 'package:pet_share/utils/access_token_parser.dart';
import 'package:pet_share/services/auth/service.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.adopterService,
    required this.shelterService,
    required this.authService,
    required this.announcementsService,
  }) : super(const SignedOutState());

  int pageNumber = 0;
  AdopterService adopterService;
  ShelterService shelterService;
  AuthService authService;
  AnnouncementService announcementsService;

  Future<void> signInOrSignUp() async {
    emit(const SigningInState());
    try {
      Credentials credentials = await authService.login();
      _setToken(credentials.accessToken);

      var role = AccessTokenParser().getRole(credentials.accessToken);
      switch (role) {
        case "adopter":
        case "shelter":
        case "admin":
          emit(SignedInState(credentials: credentials));
          break;
        case "unassigned":
          emit(ChooseRegisterTypeState(
            pageNumber: pageNumber,
          ));
          break;
        default:
          emit(ErrorState(error: 'Unexpected role: $role'));
          break;
      }
    } catch (e) {
      emit(ErrorState(
        error: e.toString(),
      ));
    }
  }

  Future<void> signOut() async {
    await authService.logout();
    emit(const SignedOutState());
  }

  Future<void> goBack() async {
    emit(const SignedOutState());
  }

  Future<void> goBackToChooseRegisterType() async {
    emit(ChooseRegisterTypeState(
      pageNumber: pageNumber,
    ));
  }

  Future<void> goBackToUserInformationPage(
    RegisterType type,
    NewUser user,
  ) async {
    switch (type) {
      case RegisterType.adopter:
        if (user is NewAdopter) {
          emit(RegisterAsAdopterState(
            adopter: user,
            email: authService.loggedInUser!.user.email ?? "",
          ));
        }
        break;
      case RegisterType.shelter:
        if (user is NewShelter) {
          emit(RegisterAsShelterState(
            shelter: user,
            email: authService.loggedInUser!.user.email ?? "",
          ));
        }
        break;
      case RegisterType.none:
        emit(ChooseRegisterTypeState(
          pageNumber: pageNumber,
        ));
        break;
    }
  }

  Future<void> goToAddressPage(
    RegisterType type,
    NewUser user,
  ) async {
    emit(AddressPageState(
      type: type,
      user: user,
    ));
  }

  Future<void> tryToSignUp(
    RegisterType type,
    int pageNumber,
  ) async {
    switch (type) {
      case RegisterType.adopter:
        emit(RegisterAsAdopterState(
          adopter: NewAdopter(),
          email: authService.loggedInUser!.user.email ?? "",
        ));
        break;
      case RegisterType.shelter:
        emit(RegisterAsShelterState(
          shelter: NewShelter(),
          email: authService.loggedInUser!.user.email ?? "",
        ));
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
      if (id.data.isNotEmpty) {
        try {
          await authService.addMetadataToUser(
            authService.loggedInUser!.user.sub,
            "adopter",
            id.data,
          );
          var credentials = await authService.login();
          _setToken(credentials.accessToken);
          emit(SignedInState(credentials: credentials));
          return;
        } on Exception catch (e) {
          emit(ErrorState(
            error: e.toString(),
          ));
          return;
        }
      } else if (id.error == ErrorType.unauthorized) {
        emit(const ErrorState(
          error: "Nie masz uprawnień do rejestracji adoptującego",
        ));
        return;
      }
    } else if (user is NewShelter) {
      var id = await shelterService.sendShelter(user);
      if (id.data.isNotEmpty) {
        try {
          await authService.addMetadataToUser(
            authService.loggedInUser!.user.sub,
            "shelter",
            id.data,
          );
          var credentials = await authService.login();
          _setToken(credentials.accessToken);
          emit(SignedInState(credentials: credentials));
          return;
        } on Exception catch (e) {
          emit(ErrorState(
            error: e.toString(),
          ));
          return;
        }
      } else if (id.error == ErrorType.unauthorized) {
        emit(const ErrorState(
          error: "Nie masz uprawnień do rejestracji schroniska",
        ));
        return;
      }
    }

    emit(
      const ErrorState(
        error: "Coś poszło nie tak. Spróbuj ponownie później",
      ),
    );
  }

  void _setToken(String token) {
    adopterService.setToken(token);
    shelterService.setToken(token);
    announcementsService.setToken(token);
  }
}

abstract class AuthState {
  const AuthState();
}

class SignedInState extends AuthState {
  const SignedInState({required this.credentials});
  final Credentials credentials;
}

class SignedOutState extends AuthState {
  const SignedOutState();
}

class ChooseRegisterTypeState extends AuthState {
  const ChooseRegisterTypeState({
    required this.pageNumber,
  });

  final int pageNumber;
}

class RegisterAsAdopterState extends AuthState {
  const RegisterAsAdopterState({
    error,
    required this.adopter,
    required this.email,
  });
  final NewAdopter adopter;
  final String email;
}

class RegisterAsShelterState extends AuthState {
  const RegisterAsShelterState({
    error,
    required this.shelter,
    required this.email,
  });
  final NewShelter shelter;
  final String email;
}

class AddressPageState extends AuthState {
  const AddressPageState({
    error,
    required this.type,
    required this.user,
  });
  final RegisterType type;
  final NewUser user;
}

class SigningInState extends AuthState {
  const SigningInState();
}

class ErrorState extends AuthState {
  const ErrorState({
    required this.error,
  });

  final String error;
}

enum RegisterType {
  adopter,
  shelter,
  none,
}

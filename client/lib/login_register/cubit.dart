import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/login_register/new_adopter.dart';
import 'package:pet_share/login_register/new_shelter.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/services/announcements/service.dart';
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
            authId: credentials.user.sub,
            email: credentials.user.email ?? "",
          ));
          break;
        default:
          emit(ErrorState(
            error: 'Unexpected role: $role',
            authId: credentials.user.sub,
            email: credentials.user.email ?? "",
          ));
          break;
      }
    } catch (e) {
      emit(ErrorState(
        error: e.toString(),
        authId: "",
        email: "",
      ));
    }
  }

  Future<void> signOut() async {
    emit(const SignedOutState());
  }

  Future<void> goBack() async {
    emit(const SignedOutState());
  }

  Future<void> goBackToChooseRegisterType(
    String authId,
    String email,
  ) async {
    emit(ChooseRegisterTypeState(
      pageNumber: pageNumber,
      authId: authId,
      email: email,
    ));
  }

  Future<void> goBackToUserInformationPage(
    RegisterType type,
    NewUser user,
    String authId,
    String email,
  ) async {
    switch (type) {
      case RegisterType.adopter:
        if (user is NewAdopter) {
          emit(RegisterAsAdopterState(
            adopter: user,
            authId: authId,
            email: email,
          ));
        }
        break;
      case RegisterType.shelter:
        if (user is NewShelter) {
          emit(RegisterAsShelterState(
            shelter: user,
            authId: authId,
            email: email,
          ));
        }
        break;
      case RegisterType.none:
        emit(ChooseRegisterTypeState(
          pageNumber: pageNumber,
          authId: authId,
          email: email,
        ));
        break;
    }
  }

  Future<void> goToAddressPage(
    RegisterType type,
    NewUser user,
    String authId,
    String email,
  ) async {
    emit(AddressPageState(
      type: type,
      user: user,
      authId: authId,
      email: email,
    ));
  }

  Future<void> tryToSignUp(
    RegisterType type,
    int pageNumber,
    String authId,
    String email,
  ) async {
    switch (type) {
      case RegisterType.adopter:
        emit(RegisterAsAdopterState(
          adopter: NewAdopter(),
          authId: authId,
          email: email,
        ));
        break;
      case RegisterType.shelter:
        emit(RegisterAsShelterState(
          shelter: NewShelter(),
          authId: authId,
          email: email,
        ));
        break;
      case RegisterType.none:
        break;
    }
    this.pageNumber = pageNumber;
  }

  Future<void> signUp(NewUser user, String authId) async {
    emit(const SigningInState());
    if (user is NewAdopter) {
      var id = await adopterService.sendAdopter(user);
      if (id.isNotEmpty) {
        try {
          await authService.addMetadataToUser(
            authId,
            "adopter",
            id,
          );
          var credentials = await authService.login();
          _setToken(credentials.accessToken);
          emit(SignedInState(credentials: credentials));
          return;
        } on Exception catch (e) {
          emit(ErrorState(
            error: e.toString(),
            authId: "",
            email: "",
          ));
          return;
        }
      }
    } else if (user is NewShelter) {
      var id = await shelterService.sendShelter(user);
      if (id.isNotEmpty) {
        try {
          await authService.addMetadataToUser(
            authId,
            "shelter",
            id,
          );
          var credentials = await authService.login();
          _setToken(credentials.accessToken);
          emit(SignedInState(credentials: credentials));
          return;
        } on Exception catch (e) {
          emit(ErrorState(
            error: e.toString(),
            authId: "",
            email: "",
          ));
          return;
        }
      }
    }

    emit(
      const ErrorState(
        error: "Coś poszło nie tak. Spróbuj ponownie później",
        authId: "",
        email: "",
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
    required this.authId,
    required this.email,
  });

  final int pageNumber;
  final String authId;
  final String email;
}

class RegisterAsAdopterState extends AuthState {
  const RegisterAsAdopterState({
    error,
    required this.adopter,
    required this.authId,
    required this.email,
  });
  final NewAdopter adopter;
  final String authId;
  final String email;
}

class RegisterAsShelterState extends AuthState {
  const RegisterAsShelterState({
    error,
    required this.shelter,
    required this.authId,
    required this.email,
  });
  final NewShelter shelter;
  final String authId;
  final String email;
}

class AddressPageState extends AuthState {
  const AddressPageState({
    error,
    required this.type,
    required this.user,
    required this.authId,
    required this.email,
  });
  final RegisterType type;
  final NewUser user;
  final String authId;
  final String email;
}

class SigningInState extends AuthState {
  const SigningInState();
}

class ErrorState extends AuthState {
  const ErrorState({
    required this.error,
    required this.authId,
    required this.email,
  });

  final String error;
  final String authId;
  final String email;
}

enum RegisterType {
  adopter,
  shelter,
  none,
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/adopter/main_screen/view.dart';
import 'package:pet_share/all_views.dart';
import 'package:pet_share/common_widgets/gif_views.dart';
import 'package:pet_share/login_register/choose_register_page.dart';
import 'package:pet_share/login_register/cubit.dart';
import 'package:pet_share/login_register/register_page.dart';
import 'package:pet_share/login_register/welcome_screen.dart';
import 'package:pet_share/shelter/main_screen/view.dart';
import 'package:pet_share/utils/access_token_parser.dart';

import 'error_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(
        adopterService: context.read(),
        shelterService: context.read(),
        authService: context.read(),
        announcementsService: context.read(),
      ),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is SignedInState) {
            var role =
                AccessTokenParser().getRole(state.credentials.accessToken);
            switch (role) {
              case "adopter":
                return const AdopterMainScreen();
              case "shelter":
                return const ShelterMainScreen();
              case "admin":
                return const AllViews();
            }

            return const CatForbiddenView(
              text: Text("Błąd aplikacji. Nie powinno cię tu być!"),
            );
          } else if (state is SignedOutState) {
            return const WelcomeScreen();
          } else if (state is ChooseRegisterTypeState) {
            return ChooseRegisterPage(
              pageNumber: state.pageNumber,
            );
          } else if (state is RegisterAsAdopterState) {
            return RegisterScreen(
              type: RegisterType.adopter,
              email: state.email,
              user: state.adopter,
            );
          } else if (state is RegisterAsShelterState) {
            return RegisterScreen(
              type: RegisterType.shelter,
              email: state.email,
              user: state.shelter,
            );
          } else if (state is AddressPageState) {
            return AddressFormPage(
              type: state.type,
              user: state.user,
            );
          } else if (state is SigningInState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            );
          } else if (state is ErrorState) {
            return ErrorPage(
              error: state.error,
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

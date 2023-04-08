import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/all_views.dart';
import 'package:pet_share/login_register/choose_register_page.dart';
import 'package:pet_share/login_register/cubit.dart';
import 'package:pet_share/login_register/register_page.dart';
import 'package:pet_share/login_register/welcome_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is SignedInState) {
            return const AllViews();
          } else if (state is SignedOutState) {
            return const WelcomeScreen();
          } else if (state is ChooseRegisterTypeState) {
            return ChooseRegisterPage(
              pageNumber: state.pageNumber,
            );
          } else if (state is RegisterAsAdopterState) {
            return RegisterScreen(
              type: RegisterType.adopter,
              email: "email",
              user: state.adopter,
            );
          } else if (state is RegisterAsShelterState) {
            return RegisterScreen(
              type: RegisterType.shelter,
              email: "email2",
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
                color: Colors.brown,
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pet_share/auth/cubit.dart';

class TemporaryAuthGate extends StatefulWidget {
  const TemporaryAuthGate({super.key});

  @override
  State<TemporaryAuthGate> createState() => _TemporaryAuthGateState();
}

class _TemporaryAuthGateState extends State<TemporaryAuthGate> {
  Credentials? credentials;
  TextEditingController controller = TextEditingController();

  late Auth0 auth0;

  @override
  void initState() {
    super.initState();
    auth0 = Auth0(
      dotenv.env['AUTH0_DOMAIN']!,
      dotenv.env['AUTH0_CLIENT_ID']!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case LoggedOutState:
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().login(auth0);
                  },
                  child: const Text("Login"),
                ),
              );
            case LoggingInState:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case LoggedInState:
              var loggedInState = state as LoggedInState;
              controller.text = loggedInState.credentials.accessToken;
              return Center(
                child: Column(
                  children: [
                    Text(
                      "Logged in as ${loggedInState.credentials.accessToken}",
                    ),
                    TextField(
                      controller: controller,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().logout(auth0);
                      },
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );
          }
          throw Exception("Unknown state");
        },
      ),
    );
  }
}

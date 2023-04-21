import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/announcements/details/view.dart';

import 'cubit.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    super.key,
    required this.error,
    required this.authId,
    required this.email,
  });

  final String error;
  final String authId;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWithBasicStyle(
          text: error,
          align: TextAlign.center,
          textScaleFactor: 2,
        ),
        TextButton(
            onPressed: () =>
                context.read<AuthCubit>().goBackToChooseRegisterType(
                      authId,
                      email,
                    ),
            child: const TextWithBasicStyle(
              text: "Wróc do wyboru roli w systemie",
              align: TextAlign.center,
              textScaleFactor: 1.3,
            ))
      ],
    ));
  }
}

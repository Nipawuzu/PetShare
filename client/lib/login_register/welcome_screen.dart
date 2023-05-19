import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/login_register/cubit.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Witamy w",
                  textScaleFactor: 2.2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.w300,
                    color: Color(0XFF3F3D56),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "images/logo.png",
                fit: BoxFit.fitWidth,
                width: 280.0,
                alignment: Alignment.bottomCenter,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {},
                child: const Text(
                  "Możesz u nas adoptować zwierzęta lub oddawać je w dobre ręce",
                  textScaleFactor: 1.6,
                  style: TextStyle(
                      fontFamily: "Quicksand",
                      color: Colors.grey,
                      letterSpacing: 1.2,
                      height: 1.3),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => context.read<AuthCubit>().signInOrSignUp(),
                  child: const Text("Zaloguj się lub zarejestruj",
                      textScaleFactor: 1.2,
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      )),
                ))
          ]),
        )
      ],
    );
  }
}

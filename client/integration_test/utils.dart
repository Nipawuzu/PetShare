// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:pet_share/adopter/main_screen/view.dart';
import 'package:pet_share/login_register/welcome_screen.dart';
import 'package:pet_share/shelter/main_screen/view.dart';

import 'users.dart';

class IntegrationTestsHelper {
  IntegrationTestsHelper(this.$);

  PatrolTester $;

  Future logOutFromMainScreen() async {
    await $(Icons.menu).tap();
    await $(Icons.logout).tap();

    expect($("Tak"), findsOneWidget);
    await $("Tak").tap();

    await $.pumpAndSettle();
  }

  Future logInFromWelcomeScreen(MockUser user) async {
    await $('Zaloguj się lub zarejestruj').tap();

    await $.native.enterTextByIndex(user.login, index: 0);
    await $.native.enterTextByIndex(user.password, index: 1);

    print("Click on LOG IN, becuse I cannot");
    await Future.delayed(const Duration(seconds: 5));
    await $.pumpAndSettle();
  }

  Future tearDown() async {
    await Future.delayed(const Duration(seconds: 5));
    await $.pumpAndSettle();
  }

  Future goToShelterMainScreen() async {
    if ($(WelcomeScreen).exists) {
      await logInFromWelcomeScreen(MockShelter());
    } else if (!$(ShelterMainScreen).exists) {
      await logOutFromMainScreen();
      await logInFromWelcomeScreen(MockShelter());
    }
  }

  Future goToAdopterMainScreen() async {
    if ($(WelcomeScreen).exists) {
      await logInFromWelcomeScreen(MockAdopter());
    } else if (!$(AdopterMainScreen).exists) {
      await logOutFromMainScreen();
      await logInFromWelcomeScreen(MockAdopter());
    }
  }

  Future addNewAnnouncement(String newPetName) async {
    expect($(ShelterMainScreen), findsOneWidget);

    await $("Dodaj ogłoszenie").tap();

    await $(const Key("image")).tap();
    print("Select an image manually");
    await Future.delayed(const Duration(seconds: 7));

    await $.enterText(find.byKey(const Key('name')), newPetName);

    await $(Icons.calendar_month).scrollTo().tap();
    await $("Wybierz").tap();

    await $(const Key('species')).scrollTo().enterText("Pies");
    await $(const Key('breed')).scrollTo().enterText("Mieszaniec");
    await $(const Key('sex')).scrollTo().tap();
    await $("chłop").tap();
    await $(const Key('description'))
        .scrollTo()
        .enterText("Bardzo fajny piesk");

    await $(const Key('next')).tap();
    await $.pumpAndSettle();

    await $(const Key("title")).scrollTo().enterText("Bobik szuka domu");
    await $(const Key('description'))
        .scrollTo()
        .enterText("Bobik szuka kochającego, nowego domu.");

    await $("Dodaj ogłoszenie").tap();
    await $.pumpAndSettle();

    expect($("Wysyłanie ogłoszenia..."), findsOneWidget);
    await $.pumpAndSettle();

    await $("Ogłoszenie zostało wysłane").tap();
    await $.pumpAndSettle();
  }

  Future applyForPet(String petName) async {
    expect($(AdopterMainScreen), findsOneWidget);

    await $(petName).scrollTo(maxScrolls: 300).tap();
    await $("Aplikuj").tap();
    await $("Wróć do widoku głównego").tap();
    await $.pumpAndSettle();
  }

  Future likeAnnouncement(String petName) async {
    expect($(AdopterMainScreen), findsOneWidget);

    await $.pumpAndSettle();
    await $(petName).scrollTo();
    await $(Icons.favorite).tap();
  }

  Future goToAnnouncement(String petName) async {
    expect($(AdopterMainScreen), findsOneWidget);

    await $.pumpAndSettle();
    await $(petName).scrollTo(maxScrolls: 150).tap();
  }

  Future acceptApplication(String petName) async {
    await $(petName).scrollTo(maxScrolls: 300).tap();
    await $.pumpAndSettle();

    await $(Icons.person).scrollTo().tap();
    await $.pumpAndSettle();

    await $("Decyzja").tap();
    await $.pumpAndSettle();
  }
}

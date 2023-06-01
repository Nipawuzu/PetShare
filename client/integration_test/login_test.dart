import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:pet_share/main.dart';

void main() {
  patrolTest(
    'Logging in as adopter to an app',
    nativeAutomation: true,
    ($) async {
      AppSetup();
      await $.pumpWidget(const PetShare());

      expect($('Zaloguj się lub zarejestruj'), findsOneWidget);
      await $('Zaloguj się lub zarejestruj').tap();

      sleep(const Duration(seconds: 2));

      if ($('Cześć').evaluate().isNotEmpty) {
        await $.native.enterTextByIndex('test@test.pl', index: 0);
        await $.native.enterTextByIndex('Test1234', index: 1);

        await $.native.tap(Selector(contentDescriptionContains: "LOG"));
      } else {
        expect($('Dodaj ogłoszenie'), findsOneWidget);

        await $(Icons.menu).tap();
      }
    },
  );
}

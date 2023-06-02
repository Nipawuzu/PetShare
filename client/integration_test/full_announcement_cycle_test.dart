import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:pet_share/main.dart';

import 'utils.dart';

void main() {
  patrolTest(
    'Full announcement cycle',
    nativeAutomation: true,
    ($) async {
      await AppSetup();
      await $.pumpWidget(const PetShare());
      await $.pumpAndSettle();

      await $.native.configure();
      var tester = IntegrationTestsHelper($);

      await tester.goToShelterMainScreen();
      await tester.AddNewAnnouncement("Bobik");

      await tester.goToAdopterMainScreen();
      await $.pumpAndSettle();
      await tester.ApplyForPet("Bobik");

      await tester.goToShelterMainScreen();
      await $.pumpAndSettle();

      await tester.AcceptApplication("Bobik");

      await tester.tearDown();
    },
  );
}

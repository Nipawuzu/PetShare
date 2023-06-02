import 'package:flutter/material.dart';
import 'package:patrol/patrol.dart';
import 'package:pet_share/main.dart';

import 'utils.dart';

void main() {
  patrolTest('Go to settings', nativeAutomation: true, ($) async {
    await appSetup();
    await $.pumpWidget(const PetShare());
    await $.pumpAndSettle();

    await $.native.configure();
    var tester = IntegrationTestsHelper($);

    await tester.goToAdopterMainScreen();

    await $(Icons.menu).tap();
    await $(Icons.settings).tap();

    await tester.tearDown();
  });
}

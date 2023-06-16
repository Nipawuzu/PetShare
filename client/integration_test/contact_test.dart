import 'package:flutter_test/flutter_test.dart';
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
    await $.pumpAndSettle();
    await tester.goToAnnouncement("Kulka");
    await $("Kontakt").tap();

    expect($("Zadzwoń"), findsOneWidget);
    expect($("Napisz maila"), findsOneWidget);

    await $("Zamknij").tap();

    await tester.tearDown();
  });
}

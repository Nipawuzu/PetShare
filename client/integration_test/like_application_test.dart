import 'package:patrol/patrol.dart';
import 'package:pet_share/main.dart';

import 'utils.dart';

void main() {
  patrolTest('Liking an announcement', nativeAutomation: true, ($) async {
    await appSetup();
    await $.pumpWidget(const PetShare());
    await $.pumpAndSettle();

    await $.native.configure();
    var tester = IntegrationTestsHelper($);

    await tester.goToAdopterMainScreen();
    await tester.likeAnnouncement("Kulka");

    await tester.tearDown();
  });
}

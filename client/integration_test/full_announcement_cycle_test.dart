import 'package:patrol/patrol.dart';
import 'package:pet_share/main.dart';

import 'utils.dart';

void main() {
  patrolTest(
    'Full announcement cycle',
    nativeAutomation: true,
    ($) async {
      await appSetup();
      await $.pumpWidget(const PetShare());
      await $.pumpAndSettle();

      await $.native.configure();
      var tester = IntegrationTestsHelper($);

      await tester.goToShelterMainScreen();
      await tester.addNewAnnouncement("Kulka");

      await tester.goToAdopterMainScreen();
      await $.pumpAndSettle();
      await tester.applyForPet("Kulka");

      await tester.goToShelterMainScreen();
      await $.pumpAndSettle();

      await tester.acceptApplication("Kulka");

      await tester.tearDown();
    },
  );
}

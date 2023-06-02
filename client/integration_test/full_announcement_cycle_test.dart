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
      await tester.addNewAnnouncement("Bobik");

      await tester.goToAdopterMainScreen();
      await $.pumpAndSettle();
      await tester.applyForPet("Bobik");

      await tester.goToShelterMainScreen();
      await $.pumpAndSettle();

      await tester.acceptApplication("Bobik");

      await tester.tearDown();
    },
  );
}

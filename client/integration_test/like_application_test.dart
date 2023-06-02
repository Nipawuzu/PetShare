import 'package:patrol/patrol.dart';
import 'package:pet_share/main.dart';

import 'utils.dart';

void main() {
  patrolTest('Liking an announcement', nativeAutomation: true, ($) async {
    await AppSetup();
    await $.pumpWidget(const PetShare());
    await $.pumpAndSettle();

    await $.native.configure();
    var tester = IntegrationTestsHelper($);

    await tester.goToAdopterMainScreen();
    await tester.likeAnnouncement("Bobik");

    await tester.tearDown();
  });
}

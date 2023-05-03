import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_share/announcements/form/view.dart';
import 'package:pet_share/services/announcements/service.dart';

import 'announcements_api_mock.dart';

void main() {
  var url = "https://petshare.com";

  Widget buildMediaQueryForTests(Widget widget) {
    return MediaQuery(
        data: const MediaQueryData(), child: MaterialApp(home: widget));
  }

  testWidgets('Send new announcement form with new pet', (tester) async {
    await tester.pumpWidget(
      buildMediaQueryForTests(NewAnnouncementForm(AnnouncementService(
          AnnouncementsAPIMock.createAnnouncementsApiMock(url), url))),
    );

    await tester.enterText(find.byKey(const Key('name')), 'test name');
    await tester.tap(find.byIcon(Icons.calendar_month));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wybierz'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('breed')), 'test breed');

    await tester.tap(find.byKey(const Key('sex')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('description')), 'test desc');
    await tester.enterText(find.byKey(const Key('species')), 'test species');
    await tester.tap(find.byKey(const Key('next')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('title')), 'test title');
    await tester.enterText(find.byKey(const Key('description')), 'test desc');
    await tester.tap(find.byKey(const Key('submit')));
    await tester.pump();
    tester.element(find.byType(CircularProgressIndicator));
    await tester.pumpAndSettle();
    tester.element(find.byIcon(Icons.done));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  });
}

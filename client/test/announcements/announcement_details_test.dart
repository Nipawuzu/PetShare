import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_share/address.dart';
import 'package:pet_share/announcements/added_announcements/after_adoption_page.dart';
import 'package:pet_share/announcements/details/gate.dart';
import 'package:pet_share/announcements/details/view.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/announcements/models/pet.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/services/announcements/service.dart';
import 'package:pet_share/shelter.dart';

import '../adopter/adopter_api_mock.dart';
import 'announcements_api_mock.dart';

void main() {
  var url = "https://petshare.com";
  var announcement = Announcement(
      title: "Test title",
      description: "Test description",
      status: AnnouncementStatus.Open,
      pet: Pet(
          shelter: Shelter(
              id: "testId",
              userName: "testShelter",
              phoneNumber: "123456789",
              email: "testShelter@gmail.com",
              address: Address(
                  city: "testCity",
                  street: "testStreet",
                  postalCode: "12-345",
                  province: "testProvince",
                  country: "testCountry"),
              fullShelterName: "testFullShelterName")));

  testWidgets('Adopt animal', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AnnouncementDetailsGate(
          announcementService: AnnouncementService(
              AnnouncementsAPIMock.createAnnouncementsApiMock(url), url),
          adopterService:
              AdopterService(AdopterAPIMock.createAdopterApiMock(url), url),
          announcement: announcement,
        ),
      ),
    );

    expect(find.byType(AnnouncementAndPetDetails), findsOneWidget);

    final adoptButtonFinder = find.widgetWithText(ElevatedButton, 'Aplikuj');
    expect(adoptButtonFinder, findsOneWidget);
    await tester.tap(adoptButtonFinder);
    await tester.pumpAndSettle();

    expect(find.byType(AfterAdoptionPage), findsOneWidget);

    final goBackButtonFinder =
        find.widgetWithText(TextButton, "Wróć do widoku głównego");
    expect(goBackButtonFinder, findsOneWidget);
  });

  testWidgets('Contact shelter', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AnnouncementDetailsGate(
          announcementService: AnnouncementService(
              AnnouncementsAPIMock.createAnnouncementsApiMock(url), url),
          adopterService:
              AdopterService(AdopterAPIMock.createAdopterApiMock(url), url),
          announcement: announcement,
        ),
      ),
    );

    expect(find.byType(AnnouncementAndPetDetails), findsOneWidget);

    final contactButtonFinder = find.widgetWithText(ElevatedButton, 'Kontakt');
    expect(contactButtonFinder, findsOneWidget);
    await tester.tap(contactButtonFinder);
    await tester.pumpAndSettle();

    final contactListFinder = find.text(
        'Skontaktuj się ze schroniskiem ${announcement.pet.shelter.fullShelterName}');
    expect(contactListFinder, findsOneWidget);

    final callShelterButtonFinder = find.widgetWithText(Expanded, "Zadzwoń");
    expect(callShelterButtonFinder, findsOneWidget);
    await tester.tap(callShelterButtonFinder);
    await tester.pump();

    final writeEmailButtonFinder = find.widgetWithIcon(Expanded, Icons.email);
    expect(writeEmailButtonFinder, findsOneWidget);
    await tester.tap(writeEmailButtonFinder);
    await tester.pump();

    final closeButtonFinder = find.widgetWithText(TextButton, "Zamknij");
    expect(closeButtonFinder, findsOneWidget);
    await tester.tap(closeButtonFinder);
    await tester.pumpAndSettle();

    expect(contactButtonFinder, findsOneWidget);
  });
}

import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:pet_share/announcements/form/view.dart';
import 'package:pet_share/common_widgets/gif_views.dart';
import 'package:pet_share/services/announcements/service.dart';

import 'announcements_api_mock.dart';

void main() {
  var url = "https://petshare.com";

  Widget buildMediaQueryForTests(Widget widget) {
    return MediaQuery(
        data: const MediaQueryData(size: Size(1080, 3000)),
        child: MaterialApp(home: widget));
  }

  testWidgets('Send new announcement form with new pet', (tester) async {
    ImagePickerPlatform.instance = MockImagePicker();

    await tester.pumpWidget(
      buildMediaQueryForTests(NewAnnouncementForm(AnnouncementService(
          AnnouncementsAPIMock.createAnnouncementsApiMock(url), url))),
    );

    await tester.tap(find.byKey(const Key("image")));
    await tester.pumpAndSettle();
    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(0, -300));

    await tester.enterText(find.byKey(const Key('name')), 'test name');
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.calendar_month));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wybierz'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('breed')), 'test breed');

    await tester.tap(find.byKey(const Key('sex')));
    await tester.pumpAndSettle();
    await tester.tap(find.text("nieznana"));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('description')), 'test desc');
    await tester.enterText(find.byKey(const Key('species')), 'test species');
    await tester.tap(find.byKey(const Key('next')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('title')), 'test title');
    await tester.enterText(find.byKey(const Key('description')), 'test desc');
    await tester.tap(find.byKey(const Key('submit')));
    await tester.pump();
    tester.element(find.byType(CatProgressIndicator));
    await tester.pumpAndSettle();
    tester.element(find.byIcon(Icons.done));
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
}

class PickedFileMock extends PickedFile {
  PickedFileMock(super.path);

  @override
  Future<Uint8List> readAsBytes() {
    String image =
        "iVBORw0KGgoAAAANSUhEUgAAABQAAAAKCAIAAAA7N+mxAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAsSURBVChTnccxDQAADMOw8YdRdIWxP9cyyY9n0j9e4RVe4RVe4RVe4RX+Ll0dZDPgDNMgagAAAABJRU5ErkJggg==";
    return Future.value(base64Decode(image));
  }
}

class MockImagePicker extends ImagePickerPlatform {
  @override
  Future<PickedFile?> pickImage(
      {required ImageSource source,
      double? maxWidth,
      double? maxHeight,
      int? imageQuality,
      CameraDevice preferredCameraDevice = CameraDevice.rear}) async {
    return Future.value(PickedFileMock(""));
  }
}

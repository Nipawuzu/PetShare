import 'package:flutter_test/flutter_test.dart';
import 'package:pet_share/services/adopter/service.dart';

import 'adopter_api_mock.dart';

void main() {
  group('AdopterAPI', () {
    var url = "https://petshare.com";
    var service = AdopterService(AdopterAPIMock.createAdopterApiMock(url), url);

    test('Post new application', () async {
      var res = await service.sendApplication(
          "cb849fa2-1033-4d6b-7c88-08db36d6f10f",
          "cb849fa2-1033-4d6b-7c88-08db36d6f10f");
      assert(res);
    });
  });
}

import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/announcements/models/pet.dart';

class SexConverter implements JsonConverter<Sex, int> {
  const SexConverter();

  @override
  Sex fromJson(int json) {
    return Sex.values[json];
  }

  @override
  int toJson(Sex? object) {
    if (object == null) {
      return 0;
    }

    return object.index;
  }
}

import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/announcements/models/pet.dart';

class SexConverter implements JsonConverter<Sex, String> {
  const SexConverter();

  @override
  Sex fromJson(String json) {
    switch (json.toLowerCase()) {
      case "male":
        return Sex.Male;
      case "female":
        return Sex.Female;
      case "doesnotapply":
        return Sex.DoesNotApply;
      default:
        return Sex.Unknown;
    }
  }

  @override
  String toJson(Sex? object) {
    if (object == null) {
      return "unknown";
    }

    switch (object) {
      case Sex.DoesNotApply:
        return "doesNotApply";
      case Sex.Female:
        return "female";
      case Sex.Male:
        return "male";
      default:
        return "unknown";
    }
  }
}

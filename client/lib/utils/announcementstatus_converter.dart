import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/announcements/models/announcement.dart';

class AnnouncementStatusConverter
    implements JsonConverter<AnnouncementStatus, int> {
  const AnnouncementStatusConverter();

  @override
  AnnouncementStatus fromJson(int json) {
    return AnnouncementStatus.values[json];
  }

  @override
  int toJson(AnnouncementStatus? object) {
    if (object == null) {
      return 0;
    }

    return object.index;
  }
}

class AnnouncementStatusConverterToString
    implements JsonConverter<AnnouncementStatus, String> {
  const AnnouncementStatusConverterToString();

  @override
  AnnouncementStatus fromJson(String str) {
    switch (str.toLowerCase()) {
      case "open":
        return AnnouncementStatus.Open;
      case "closed":
        return AnnouncementStatus.Closed;
      case "deleted":
        return AnnouncementStatus.Deleted;
      default:
        return AnnouncementStatus.Open;
    }
  }

  @override
  String toJson(AnnouncementStatus? object) {
    if (object == null) {
      return "Open";
    }

    switch (object) {
      case AnnouncementStatus.Closed:
        return "Closed";
      case AnnouncementStatus.Deleted:
        return "Deleted";
      case AnnouncementStatus.Open:
        return "Open";
      default:
        return "Open";
    }
  }
}

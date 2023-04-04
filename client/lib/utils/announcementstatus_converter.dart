import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/announcements/announcement.dart';

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

import 'package:pet_share/announcements/announcement.dart';
import 'package:pet_share/shelter.dart';

class Application {
  Application({
    required this.announcement,
    required this.user,
    required this.dateOfApplication,
    required this.lastUpdateDate,
    this.isWithdrew = false,
  });

  Application.newlyCreated({
    required this.announcement,
    required this.user,
  })  : dateOfApplication = DateTime.now(),
        lastUpdateDate = DateTime.now(),
        isWithdrew = false;

  User user;
  Announcement announcement;
  DateTime dateOfApplication;
  DateTime lastUpdateDate;
  bool isWithdrew;

  // ignore: todo
  // TODO: add request to an endpoint
  bool withdraw() {
    isWithdrew = false;

    return true;
  }
}

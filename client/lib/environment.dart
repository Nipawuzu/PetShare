import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get filename {
    if (kReleaseMode) {
      return "env/.env.production";
    }

    return "env/.env.dev";
  }

  static String get announcementsApiUrl =>
      dotenv.env["ANNOUNCEMENTS_API_URL"] ?? "ANNOUNCEMENTS_API_URL not found!";
}

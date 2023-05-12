import 'dart:convert';

class AccessTokenParser {
  String getRole(String accessToken) {
    var payload = accessToken.split(".")[1];
    var decodedPayload =
        utf8.decode(base64Url.decode(base64Url.normalize(payload)));
    var role = json.decode(decodedPayload)["role"];
    return role;
  }

  String getDbId(String accessToken) {
    var payload = accessToken.split(".")[1];
    var decodedPayload = utf8.decode(base64Url.decode(payload));
    var dbId = json.decode(decodedPayload)["db_id"];
    return dbId;
  }
}

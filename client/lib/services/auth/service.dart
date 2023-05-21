import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  AuthService(this._dio);

  final Dio _dio;

  Auth0? _auth0;
  Credentials? loggedInUser;

  Auth0 get auth0 {
    _auth0 ??= Auth0(
      dotenv.env['AUTH0_DOMAIN']!,
      dotenv.env['AUTH0_CLIENT_ID']!,
    );

    return _auth0!;
  }

  Future<Credentials?> relogin() async {
    return await auth0.credentialsManager.hasValidCredentials()
        ? await auth0.credentialsManager.credentials()
        : null;
  }

  Future<Credentials> login() async {
    loggedInUser = await auth0
        .webAuthentication(
          scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'],
        )
        .login(audience: dotenv.env['AUTH0_AUDIENCE']);

    if (loggedInUser != null) {
      auth0.credentialsManager.storeCredentials(loggedInUser!);
    }
    return loggedInUser!;
  }

  Future<void> addMetadataToUser(
    String authId,
    String role,
    String dbId,
  ) async {
    var token = await _getToken();
    var url = dotenv.env['AUTH0_MANAGEMENT_URL'];

    await _dio.patch(
      "$url/api/v2/users/$authId",
      data: {
        "app_metadata": {
          "role": role,
          "db_id": dbId,
        }
      },
      options: Options(headers: {
        "Authorization": 'Bearer $token',
        "HttpHeaders.contentTypeHeader": "application/json",
      }),
    );
  }

  Future<String> _getToken() async {
    var url = dotenv.env['AUTH0_MANAGEMENT_URL'];

    var response = await _dio.post(
      "$url/oauth/token",
      data: {
        "client_id": dotenv.env['AUTH0_MANAGEMENT_CLIENT_ID'],
        "client_secret": dotenv.env['AUTH0_MANAGEMENT_CLIENT_SECRET'],
        "audience": dotenv.env['AUTH0_MANAGEMENT_AUDIENCE'],
        "grant_type": "client_credentials",
      },
      options: Options(
        headers: {
          "HttpHeaders.contentTypeHeader": "application/json",
        },
      ),
    );
    return response.data["access_token"];
  }

  Future<void> logout() async {
    await auth0
        .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
        .logout();

    await auth0.credentialsManager.clearCredentials();
  }
}

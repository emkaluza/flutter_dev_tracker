import 'dart:io';

import 'package:flutter_dev_tracker/utils/app_preferences.dart';
import 'package:http/http.dart' as http;

class HttpRequest {
  static const Duration _TIMEOUT = Duration(seconds: 10);
  static const Map<String, String> _DEFAULT_HEADERS = {"Content-type": "application/json"};
  static const String _PATH_AUTH_SERVICE = "/auth";
  static const String _PATH_RECORDS_SERVICE = "/devtimerecords?month=%i&year=%i";
  static String _authToken;

  static bool _isAuthorized(){
    return _authToken.isNotEmpty;
  }

  static Future createAuthRequest(final String _userName, final String _userPassword){
    return http.post(_createServiceAddress(_PATH_AUTH_SERVICE),
        headers: _DEFAULT_HEADERS,
        body: '{"username":"$_userName","password":"$_userPassword"}').timeout(_TIMEOUT)
        .then((http.Response _response){
      if(_response != null && HttpStatus.ok == _response.statusCode && _response.body.isNotEmpty) {
        _authToken = _response.body;
        return _response;
      }
      throw Exception("createAuthRequest: ${_response.body}");
    });
  }

  static Future createGetDevtimeRecordsRequest(final int month, final int year) {
    if(!_isAuthorized()){
      throw UnauthorizedException();
    }
    var copy = Map.from(_DEFAULT_HEADERS)
      ..addAll({"Authorization":_authToken});
    return http.get("$AppPreferences.HOST:$AppPreferences.PORT$_PATH_RECORDS_SERVICE",
        headers: copy)
        .timeout(_TIMEOUT);
  }

  static String _createServiceAddress(final String _servicePath) {
    return "${AppPreferences.appPreferences.getString(AppPreferences.HOST)}:${AppPreferences.appPreferences.getInt(AppPreferences.PORT).toString()}$_servicePath";
  }
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException([this.message = ""]);
  String toString() => "UnauthorizedException: $message";
}
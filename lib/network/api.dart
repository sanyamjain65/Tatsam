import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tatsam/utils/Constants.dart';

const String APP_VERSION_HEADER_KEY = 'x-app-version';
const String APP_VERSION_UPDATE_HEADER_KEY = 'x-update-app-version';

class ApiClient {
  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal();

  static final ApiClient _instance = ApiClient._internal();

  //get it from shared preferences
  final String _apiBaseUrl = baseUrl;

  Map<String, String> _getRequestHeaderContentTypeOnly() {
    return <String, String>{'Content-Type': 'application/json'};
  }

  Future<Map<String, dynamic>> get(String endPoint,
      {bool withoutHeaders = false, Map<String, dynamic> queryParams}) async {
    debugPrint('endPoint:$endPoint');
    http.Response response;

    dynamic url;
    //when query params are to be passed in GET request
    if (queryParams != null) {
      String queryString = Uri(queryParameters: queryParams).query;
      url = _apiBaseUrl + endPoint + '?' + queryString;
    } else {
      url = _apiBaseUrl + endPoint;
    }
    response = await http.get(url);

    return handleResponse(response);
  }

  Future<Map<String, dynamic>> handleResponse(dynamic response) async {
    debugPrint('responseStatusCode:' + response.statusCode.toString());
    debugPrint('responseBody:' + response.body);
    final Map<String, String> responseHeader = response.headers;
    debugPrint('responseHeaders: ${responseHeader.toString()}');

    //create response object
    dynamic responseBody = {'status': response.statusCode};
    if (response.body != '' &&
        responseHeader['content-type'].startsWith('application/json')) {
      dynamic decodedResponse = jsonDecode(response.body);
      responseBody.addAll(decodedResponse);
    } else if (response.statusCode != 200 &&
        response.statusCode != 201 &&
        response.statusCode != 204) {
      responseBody.addAll(<String, dynamic>{'message': 'Something went wrong'});
    }

    return Future<Map<String, dynamic>>.value(responseBody);
  }
}

import 'dart:convert';

import 'package:http/http.dart' as Http;
import 'package:json_convert/network/api_links.dart';

class ApiClient {
  static final ApiClient _appManager = ApiClient._internal();

  factory ApiClient() {
    return _appManager;
  }

  ApiClient._internal();

  Future<String> getUsersList(limit) async {
    try {
      Http.Response res =
          await Http.get('$get_users?limit=$limit', headers: {'app-id': app_id});
      return res.body;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }
}

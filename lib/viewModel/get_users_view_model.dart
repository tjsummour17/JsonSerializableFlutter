import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_convert/model/user.dart';
import 'package:json_convert/network/api_client.dart';

class GetUsersViewModel extends ChangeNotifier {
  List<User> _users;

  List<User> get users => _users;

  List<User> parseUser(responseBody) {
    try {
      var data = jsonDecode(responseBody);
      final parsed = data['data'].cast<Map<String, dynamic>>();
      return parsed.map<User>((json) => User.fromJson(json)).toList();
    } on Exception catch (e) {
      return [];
    }
  }

  Future getUsersFromApi(int limit) async {
    String response = await ApiClient().getUsersList(limit);
    _users = parseUser(response);
  }
}

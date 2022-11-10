import 'dart:convert';
import 'package:http/http.dart';
import 'package:dnd_handy_flutter/models/base_dnd_model.dart';

class ApiService {
  final String _host = 'dnd5eapi.co';

  Future<dynamic> getRequest(String? path) async {
    Response res = await get(
      Uri.https(_host, path ?? ''),
    );
    if (res.statusCode == 200) {
      return BaseDndModel.generate(jsonDecode(res.body));
    } else {
      throw "Failed to complete GET request.";
    }
  }
}
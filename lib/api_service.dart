import 'dart:convert';
import 'package:http/http.dart';

Future<dynamic> getApiRequest(String? path) async {
  if (path == null) {
    return null;
  }
  Response res = await get(
    Uri.https('dnd5eapi.co', path),
  );
  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  } else {
    throw "Failed to complete GET request.";
  }
}
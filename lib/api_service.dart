import 'dart:convert';
import 'package:http/http.dart';
import 'package:dnd_handy_flutter/main.dart';
import 'package:dnd_handy_flutter/json_objects.dart';

// Timestamp in seconds.
int timestamp() => DateTime.now().millisecondsSinceEpoch ~/ 1000;

Future<JsonObject?> getRequest(String? path) async {
  if (path == null) {
    return null;
  } 
  final result = cache.get(path);
  if (result == null) { 
    return await getRequestRefresh(path);
  }
  if (result is! Map<dynamic, dynamic>) {
    throw "Unsupported: Not a JSON object";
  }
  // Cast to JsonObject
  return result.cast<String, dynamic>();
}

Future<JsonObject> getRequestRefresh(String path) async {
  final request = await _getApiRequest(path);
  final JsonObject result = request is JsonArray
    ? {
      'count': request.length,
      'results': request,
    }
    : request;
  result["last_refresh"] = timestamp();
  cache.put(path, result);
  return result;
}

Future<dynamic> _getApiRequest(String path) async {
  Response res = await get(
    Uri.https('dnd5eapi.co', path),
  );
  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  } else {
    throw "Failed to complete GET request.";
  }
}

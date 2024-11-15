import 'dart:convert';
import 'dart:io';

import 'package:dnd_handy_flutter/models/common.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';

const cacheBoxName = 'dnd5e-bits';

Future<Json?> getRequest(String? path) async {
  if (path == null) {
    return null;
  }
  final Json? result = await Hive.lazyBox(cacheBoxName)
      .get(path)
      .then((v) => v is Json ? v : v?.cast<String, dynamic>());
  if (result == null) {
    // Get data from API
    try {
      return await getRequestRefresh(path);
    } catch (e) {
      if (e is SocketException) {
        throw e.message;
      }
      rethrow;
    }
  }
  const refreshPeriod = Duration(days: 14);
  if (DateTime.timestamp()
      .subtract(refreshPeriod)
      .isAfter(result['last_refresh'])) {
    // Refresh data from API
    try {
      return await getRequestRefresh(path);
    } finally {}
  }
  return result;
}

Future<Json> getRequestRefresh(String path) async {
  final result = await _getApiRequest(path);
  result['last_refresh'] = DateTime.timestamp();
  Hive.lazyBox(cacheBoxName).put(path, result);
  return result;
}

Future<Json> _getApiRequest(String path) async {
  Response res = await get(Uri.https('dnd5eapi.co', path));
  if (res.statusCode != 200) {
    throw 'Failed to complete GET request: HTTP code ${res.statusCode}';
  }
  final json = jsonDecode(
    res.body,
    reviver: (_, v) => v is Map ? v.cast<String, dynamic>() : v,
  );
  return json is List
      ? {
          'count': json.length,
          'results': json.cast<Json>(),
        }
      : json;
}

void initBoxes(String path) async {
  Hive.init(path);
  await Hive.openLazyBox(cacheBoxName);
}

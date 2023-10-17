import 'dart:convert';

import 'package:dnd_handy_flutter/models/common.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class DndApiService {
  static final DndApiService _instance = DndApiService._internal();

  factory DndApiService() => _instance;

  late final Future<LazyBox> _cache;

  Future<Json?> getRequest(String? path) async {
    if (path == null) {
      return null;
    }
    final Map? result = await (await _cache).get(path);
    if (result == null ||
        timestamp() - result['last_refresh'] >= refreshPeriod) {
      return await getRequestRefresh(path);
    }
    return result is Json ? result : result.cast<String, dynamic>();
  }

  Future<Json> getRequestRefresh(String path) async {
    final result = await _getApiRequest(path);
    result['last_refresh'] = timestamp();
    (await _cache).put(path, result);
    return result;
  }

  Future<Json> _getApiRequest(String path) async {
    Response res = await get(
      Uri.https('dnd5eapi.co', path),
    );
    if (res.statusCode != 200) {
      throw 'Failed to complete GET request.';
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

  /// Timestamp in seconds.
  static int timestamp() => DateTime.now().millisecondsSinceEpoch ~/ 1000;

  /// Refresh period in seconds (1 day).
  static const int refreshPeriod = 3600 * 24;

  static final Finalizer<LazyBox> _finalizer = Finalizer(_closeBox);

  DndApiService._internal() {
    _cache = _init();
    _cache.then((box) => _finalizer.attach(this, box, detach: this));
  }

  static Future<LazyBox> _init() async {
    final localDir = await getApplicationSupportDirectory();
    Hive.init(localDir.path);
    return Hive.openLazyBox('dnd5e-bits');
  }

  static _closeBox(LazyBox box) async {
    await box.compact();
    await box.close();
  }

  /// Close the cache manually.
  close() async {
    _closeBox(await _cache);
    _finalizer.detach(this);
  }
}

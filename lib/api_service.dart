import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:path_provider/path_provider.dart';

class DndApiService {
  static final DndApiService _instance = DndApiService._internal();

  factory DndApiService() => _instance;

  late final Future<LazyBox> _cache;
  
  Future<JsonObject?> getRequest(String? path) async {
    if (path == null) {
      return null;
    } 
    final result = await (await _cache).get(path);
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
    (await _cache).put(path, result);
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

  /// Timestamp in seconds.
  static int timestamp() => DateTime.now().millisecondsSinceEpoch ~/ 1000;

  static final Finalizer<LazyBox> _finalizer = Finalizer(_closeBox);

  DndApiService._internal() {
    _cache = _init();
    _cache.then(
      (box) => _finalizer.attach(this, box, detach: this)
    );
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

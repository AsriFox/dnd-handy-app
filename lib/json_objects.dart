// TODO: Hive typed objects
typedef JsonObject = Map<dynamic, dynamic>;
typedef JsonArray = List<dynamic>;

String getTitle(String path) {
  final it = path.split('/');
  final title = it.last.replaceAll('-', ' ');
  return '${title[0].toUpperCase()}${title.substring(1)}';
}

String getCategoryName(String path) {
  final it = path.split('/');
  return it[it.length - 2].replaceAll('-', ' ');
}

import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

Future showDescPopup(BuildContext context, DndRef it) =>
  showDialog(
    context: context,
    builder: (ctx) => descPopup(ctx, it),
  );

AlertDialog descPopup(BuildContext context, DndRef it) => 
  AlertDialog(
    title: Text(
      it.name, 
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    titlePadding: const EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 4.0),
    contentPadding: const EdgeInsets.all(4.0),
    content: SizedBox(
      width: double.maxFinite,
      child: FutureBuilder(
        future: getApiRequest(it.url),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            try {
              return ArticlePage.fromJson(
                snapshot.data as Map<String, dynamic>
              );
            } catch (e) {
              return const Center(
                child: Text('Nothing found'),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    ),
    actions: [
      IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.close),
      ),
    ],
  );
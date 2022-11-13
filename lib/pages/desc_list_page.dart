import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class DescListPage extends StatelessWidget {
  const DescListPage({
    super.key,
    required this.items,
    // required this.pages,
  });

  final List<DndRef> items;
  // final Map<String, Future<dynamic>> pages;

  factory DescListPage.fromJsonArray(List<dynamic> array) {
    final items = array.map(
      (it) => DndRef.fromJson(it)
    );
    // final pages = {
    //   for (var it in items) 
    //     it.index :  getApiRequest(it.url)
    // };
    return DescListPage(
      items: items.toList(),
      // pages: pages
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, i) {
        return items[i].build(
          onTap: (it) async {
            // try {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(it.name),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: FutureBuilder(
                      future: getApiRequest(it.url),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ArticlePage.fromJson(
                            snapshot.data as Map<String, dynamic>
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close),
                    ),
                  ],
                )
              );
            // }
            // catch (_) {
            //   ScaffoldMessenger.of(context)
            //     .showSnackBar(
            //       const SnackBar(
            //         content: Text("Nothing found")
            //       )
            //     );
            // }
          }
        );
      } 
    );
  }
}
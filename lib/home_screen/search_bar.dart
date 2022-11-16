import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/page_screen.dart';
import 'package:dnd_handy_flutter/search_delegate.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({
    super.key,
    required this.title,
    this.leading,
  });

  final String title;
  final IconButton? leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: leading,
      actions: [
        IconButton(
          onPressed: () {
            showSearch(
              context: context, 
              delegate: CustomSearchDelegate(),
            ).then((query) async => 
              query is String
                ? DndRef(
                  index: query.split('/').last,
                  name: PageScreen.getTitle(query),
                  url: query,
                )
                : query as DndRef
            ).then(
              (ref) => showPageScreen(context, ref)
            ).catchError((e) {
              ScaffoldMessenger.of(context)
                .showSnackBar(
                  SnackBar(
                    content: Text("Nothing found at '$e'")
                  )
                );
            });
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }
  
  @override
  Size get preferredSize => 
    const Size.fromHeight(kToolbarHeight);
}

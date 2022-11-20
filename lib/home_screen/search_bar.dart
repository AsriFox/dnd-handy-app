import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/page_screen/pages_build.dart';
import 'package:dnd_handy_flutter/home_screen/search_delegate.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
  });

  final String title;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: leading,
      actions: trailing != null
        ? [ buildSearchButton(context), trailing! ]
        : [ buildSearchButton(context) ],
    );
  }
  
  @override
  Size get preferredSize => 
    const Size.fromHeight(kToolbarHeight);
}

IconButton buildSearchButton(BuildContext context) => 
  IconButton(
    onPressed: () {
      showSearch(
        context: context, 
        delegate: CustomSearchDelegate(),
      ).then((query) async {
        if (query == null) { 
          throw "nullQuery";
        }
        return query is String
          ? DndRef(
            index: query.split('/').last,
            name: getTitle(query),
            url: query,
          )
          : query is DndRef
            ? query
            : throw query;
      }).then(
        (ref) => gotoPage(context, ref)
      ).catchError((e) {
        if (e != "nullQuery") {
          ScaffoldMessenger.of(context)
            .showSnackBar(
              SnackBar(
                content: Text("Nothing found at '$e'")
              )
            );
        }
      });
    },
    icon: const Icon(Icons.search),
  );
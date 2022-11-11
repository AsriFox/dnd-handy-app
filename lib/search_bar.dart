import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/page_screen.dart';
import 'package:dnd_handy_flutter/search_delegate.dart';

AppBar buildSearchBar({
  required BuildContext context,
  required String title,
  IconButton? leading,
}) => AppBar(
  title: Text(title),
  leading: leading,
  actions: [
    IconButton(
      onPressed: () {
        showSearch(
          context: context,
          delegate: CustomSearchDelegate(),
        ).then((url) {
          final nav = Navigator.of(context);
          nav.push(
            MaterialPageRoute(
              builder: (context) => 
                PageScreen.request(url),
            )
          );
        }).catchError((e) {
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

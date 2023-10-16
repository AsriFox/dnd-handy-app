import 'package:flutter/material.dart';

class WrappedListView extends StatelessWidget {
  WrappedListView({super.key, required List<Widget> children})
      : childrenDelegate = SliverChildListDelegate(children);

  WrappedListView.builder({
    super.key,
    required Widget Function(BuildContext, int) builder,
    int? childCount,
  }) : childrenDelegate = SliverChildBuilderDelegate(
          builder,
          childCount: childCount,
        );

  final SliverChildDelegate childrenDelegate;

  static const _maxItemWidth = 450.0;
  static const _maxWidth = _maxItemWidth * 3;
  static const _padding = 20.0;
  static const _widthConstraint = _maxWidth + 2 * _padding;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (_, constraints) => GridView.custom(
          clipBehavior: Clip.antiAlias,
          scrollDirection: Axis.vertical,
          padding: constraints.maxWidth >= _widthConstraint
              ? EdgeInsets.symmetric(
                  vertical: _padding,
                  horizontal: (constraints.maxWidth - _maxWidth) / 2,
                )
              : const EdgeInsets.all(_padding),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: _maxItemWidth,
            mainAxisExtent: 55,
          ),
          childrenDelegate: childrenDelegate,
        ),
      );

  // Center(
  //   child: ConstrainedBox(
  //     constraints: BoxConstraints.loose(const Size.fromWidth(_maxWidth)),
  //     child: GridView.custom(
  //       clipBehavior: Clip.antiAlias,
  //       scrollDirection: Axis.vertical,
  //       padding: const EdgeInsets.all(_padding),
  //       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
  //         maxCrossAxisExtent: _maxItemWidth,
  //         mainAxisExtent: 47.0,
  //       ),
  //       childrenDelegate: childrenDelegate,
  //     ),
  //   ),
  // );
}

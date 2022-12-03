import 'package:flutter/material.dart';

/// Delegate for the icon that controls the expansion status of the toolbar
class ExpandIconDelegate extends SliverPersistentHeaderDelegate {
  final double? _size;
  final bool _isExpanded;
  final void Function() _setState;

  ExpandIconDelegate(this._size, this._isExpanded, this._setState);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: _size,
      width: _size,
      color: Colors.transparent,
      child: IconButton(
        constraints: BoxConstraints(
          maxHeight: _size!,
          maxWidth: _size!,
        ),
        iconSize: _size! * 3 / 5,
        icon: Icon(
          _isExpanded ? Icons.expand_less : Icons.expand_more,
          color: Colors.grey,
        ),
        onPressed: () async {
          _setState.call();
        },
      ),
    );
  }

  @override
  double get maxExtent => _size!;

  @override
  double get minExtent => _size!;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

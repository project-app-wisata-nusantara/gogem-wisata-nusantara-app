// lib/screens/detail/widgets/sticky_tab_bar_delegate.dart

import 'package:flutter/material.dart';

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  const StickyTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(
        context,
      ).scaffoldBackgroundColor, // Background agar transisi mulus
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(StickyTabBarDelegate oldDelegate) {
    return false;
  }
}

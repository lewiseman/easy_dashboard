import 'package:flutter/material.dart';

abstract class SideTile {}

class SideBarTile extends SideTile {
  /// title to display on the app bar
  final Widget title;

  /// name to show on the side bar tiles
  final String name;

  /// icon to show on the side bar tiles
  final IconData icon;

  /// widget to show when clicked or active
  final Widget body;

  ///a tile for the [EasyDrawer] navigation
  SideBarTile({
    required this.icon,
    required this.name,
    required this.title,
    required this.body,
  });
}

class SideBarDivider extends SideTile {
  final double height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;
  SideBarDivider(
      {required this.height,
      this.thickness,
      this.indent,
      this.endIndent,
      this.color});
}

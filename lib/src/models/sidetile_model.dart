import 'package:flutter/material.dart';

abstract class SideTile {}

class SideBarTile extends SideTile {
  final Widget title;
  final String name;
  final IconData icon;
  final Widget body;
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

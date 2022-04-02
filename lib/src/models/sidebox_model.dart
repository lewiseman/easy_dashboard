import 'package:flutter/material.dart';

class SideBox {
  /// space to be occupied by the widget
  final double height;

  /// whether is should scroll with the rest or not
  final bool scrollable;

  /// an additional widget to show on the side bar
  final Widget? child;

  /// an additional widget to show on the side bar
  const SideBox({
    required this.height,
    this.scrollable = false,
    this.child,
  });
}

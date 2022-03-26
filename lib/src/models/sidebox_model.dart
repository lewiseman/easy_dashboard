import 'package:flutter/material.dart';

class SideBox {
  final double height;
  final bool scrollable;
  final Widget? child;
  const SideBox({
    required this.height,
    this.scrollable = false,
    this.child,
  });
}

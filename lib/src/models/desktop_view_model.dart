import 'package:flutter/material.dart';

class DesktopView {
  /// preview size of the drawer
  final double previewSize;

  /// full size of the drawer
  final double sideBarWidth;

  /// whether the app bar to span the whole width or not
  final bool fullAppBar;

  /// border prroperties
  final BorderSide border;

  /// properties for desktop
  const DesktopView({
    this.previewSize = 70,
    this.sideBarWidth = 250,
    this.fullAppBar = true,
    this.border = const BorderSide(width: 1, color: Colors.black),
  });
}

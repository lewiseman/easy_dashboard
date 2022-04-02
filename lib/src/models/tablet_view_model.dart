import 'package:flutter/material.dart';

class TabletView {
  /// preview size of the drawer
  final double previewSize;

  /// whether the app bar to span the whole width or not
  final bool fullAppBar;

  /// border prroperties
  final BorderSide border;

  /// properties fot tablet view
  const TabletView({
    this.previewSize = 70,
    this.fullAppBar = true,
    this.border = const BorderSide(width: 1, color: Colors.black),
  });
}

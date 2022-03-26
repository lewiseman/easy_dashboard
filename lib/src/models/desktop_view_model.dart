import 'package:flutter/material.dart';

class DesktopView {
  final double previewSize;
  final double sideBarWidth;
  final bool fullAppBar;
  final BorderSide border;
  const DesktopView({
    this.previewSize = 70,
    this.sideBarWidth = 250,
    this.fullAppBar = true,
    this.border = const BorderSide(width: 1, color: Colors.black),
  });
}

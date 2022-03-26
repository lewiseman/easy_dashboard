import 'package:flutter/material.dart';

class TabletView {
  final double previewSize;
  final bool fullAppBar;
  final BorderSide border;
  const TabletView({
    this.previewSize = 70,
    this.fullAppBar = true,
    this.border = const BorderSide(width: 1, color: Colors.black),
  });
}

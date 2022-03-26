import 'package:flutter/material.dart';

class MobileView {
  final double sideBarOpenSize;
  final bool isDraggable;
  final double appBarElevation;
  final double? appBarToolbarHeight;
  final double? appBarToolbarHeightLeadingWidth;
  final TextStyle? toolbarTextStyle;
  final bool primary = true;
  final bool excludeHeaderSemantics = false;
  final double appBatoolbarOpacity = 1.0;
  final double appBabottomOpacity = 1.0;
  final Widget? appBarFlexibleSpace;
  final PreferredSizeWidget? appBarbottom;

  const MobileView({
    this.appBarElevation = 0.0,
    this.isDraggable = true,
    this.sideBarOpenSize = 256,
    this.appBarToolbarHeight,
    this.appBarToolbarHeightLeadingWidth,
    this.toolbarTextStyle,
    this.appBarFlexibleSpace,
    this.appBarbottom,
  });
}

import 'package:flutter/material.dart';

class MobileView {
  /// size of the side bar when opened
  final double sideBarOpenSize;

  /// if side bar can be opened by dragging from left to right
  final bool isDraggable;

  /// app bar elevation
  final double appBarElevation;

  /// app bar tool bar height
  final double? appBarToolbarHeight;

  /// app bar leading width
  final double? appBarToolbarHeightLeadingWidth;

  /// tool bar text style
  final TextStyle? toolbarTextStyle;

  /// primary [AppBar]
  final bool primary = true;

  ///  excludeHeaderSemantics [AppBar]
  final bool excludeHeaderSemantics = false;

  ///  appBatoolbarOpacity [AppBar]
  final double appBatoolbarOpacity = 1.0;

  ///  appBabottomOpacity [AppBar]
  final double appBabottomOpacity = 1.0;

  ///  appBarFlexibleSpace [AppBar]
  final Widget? appBarFlexibleSpace;

  /// appBarBottom [AppBar]
  final PreferredSizeWidget? appBarbottom;

  /// properties for mobile
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

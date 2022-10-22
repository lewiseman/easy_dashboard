import 'package:flutter/material.dart';

typedef DrawerBuilder = Widget Function(Size context, Widget? child);

enum EasyDeviceMode {
  mobile,
  tablet,
  desktop,
}

enum ScrollableDrawers {
  topOnly,
  bottomOnly,
  both,
  none,
}

enum EasyNavigationType { flatNavigation }

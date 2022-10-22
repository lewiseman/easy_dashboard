import 'package:easy_dashboard/src/components/appbars/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EasyCustomAppBar extends EasyAppBar {
  final Widget? child;
  const EasyCustomAppBar({Key? key, this.child, required super.height})
      : super(key: key);

  // @override
  // Size get preferredSize => preferredSize;

  @override
  Widget buildAppBar(BuildContext context) {
    return child ?? const SizedBox.shrink();
  }
}

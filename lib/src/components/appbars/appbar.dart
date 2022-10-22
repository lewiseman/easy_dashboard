import 'package:flutter/material.dart';

abstract class EasyAppBar extends StatelessWidget
    implements PreferredSizeWidget {
      final double height;
  const EasyAppBar({Key? key , required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildAppBar(context);
  }

  @protected
  Widget buildAppBar(BuildContext context);

  @override
  Size get preferredSize => Size.fromHeight(height);
}

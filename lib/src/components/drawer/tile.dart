import 'package:easy_dashboard/src/models/sidetile_model.dart';
import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final bool showTitle;
  final bool isSelected;
  final SideBarTile tile;
  final Color selectedColor;
  final Color selectedTextColor;
  final Color selectedTileColor;
  final Color tileColor;
  final Color textColor;
  final Color iconColor;
  final Color selectedIconColor;
  final Color hoverColor;

  final VoidCallback? onTap;
  const DrawerTile({
    Key? key,
    this.isSelected = false,
    required this.tile,
    required this.selectedColor,
    required this.selectedTileColor,
    this.showTitle = false,
    this.onTap,
    required this.tileColor,
    required this.selectedTextColor,
    required this.textColor,
    required this.selectedIconColor,
    required this.iconColor,
    required this.hoverColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4, top: 4),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.hardEdge,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: ListTile(
          tileColor: tileColor,
          autofocus: isSelected,
          selected: isSelected,
          hoverColor: isSelected ? selectedTileColor : hoverColor,
          selectedColor: selectedColor,
          textColor: textColor,
          focusColor: selectedTileColor,
          selectedTileColor: selectedTileColor,
          iconColor: iconColor,
          leading: Icon(
            tile.icon,
            color: isSelected ? selectedIconColor : iconColor,
          ),
          title: showTitle
              ? Text(
                  tile.name,
                  style: TextStyle(
                    color: isSelected ? selectedTextColor : textColor,
                  ),
                )
              : null,
          onTap: () {
            onTap?.call();
          },
        ),
      ),
    );
  }
}

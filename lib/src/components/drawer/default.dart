import 'package:easy_dashboard/src/components/drawer/tile.dart';
import 'package:easy_dashboard/src/models/body_model.dart';
import 'package:easy_dashboard/src/models/sidebox_model.dart';
import 'package:easy_dashboard/src/models/sidetile_model.dart';
import 'package:easy_dashboard/src/utils/enums.dart';
import 'package:flutter/material.dart';

class EasyDrawer extends StatefulWidget {
  final List<SideTile>? tiles;

  /// actions to be taken when a tile is tapped
  /// This is mostly switching the body of the dashboard
  final ValueChanged<EasyBody>? onTileTapped;

  /// widget to display at the top when the drawer is fully opened
  final SideBox? topWidget;

  /// widget to display at the top when the drawer is partially opened
  final SideBox? topSmallWidget;

  /// widget to display at the bottom when the drawer is fully opened
  final SideBox? bottomWidget;

  /// widget to display at the bottom when the drawer is partially opened
  final SideBox? bottomSmallWidget;

  /// the size of the drawer when fully opened
  final Size size;

  /// tile selected color
  final Color? selectedColor;

  /// tile text selected color
  final Color? selectedTextColor;

  /// selected tile color
  final Color? selectedTileColor;

  /// tile color
  final Color? tileColor;

  /// selected icon color
  final Color? selectedIconColor;

  /// text color
  final Color? textColor;

  /// icon color
  final Color? iconColor;

  /// hover color
  final Color? hoverColor;

  /// ## Easy Drawer
  /// An optional drawer to use if you do not wish to build one yourself.
  const EasyDrawer({
    Key? key,
    this.tiles,
    this.topWidget,
    this.bottomWidget,
    this.topSmallWidget,
    this.bottomSmallWidget,
    this.onTileTapped,
    this.tileColor,
    this.textColor,
    this.iconColor,
    this.selectedColor,
    this.selectedTileColor,
    this.selectedTextColor,
    this.selectedIconColor,
    this.hoverColor,
    required this.size,
  }) : super(key: key);

  @override
  State<EasyDrawer> createState() => _EasyDrawerState();
}

class _EasyDrawerState extends State<EasyDrawer> {
  int selected = 0;
  bool get showFull => (widget.size.width > 100);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getTopWidget(
              scrollBig: false,
              scrollSmall: false,
            ) ??
            const SizedBox(),
        SizedBox(
          height: getTilesHeight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                getTopWidget(
                      scrollBig: true,
                      scrollSmall: true,
                    ) ??
                    const SizedBox(),
                if (widget.tiles != null)
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.tiles?.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (widget.tiles?[index] is SideBarTile) {
                        var tl = widget.tiles?[index] as SideBarTile;
                        return DrawerTile(
                          isSelected: selected == index,
                          showTitle: showFull,
                          tile: tl,
                          onTap: () {
                            setState(() => selected = index);
                            widget.onTileTapped?.call(EasyBody(
                              child: tl.body,
                              title: tl.title,
                            ));
                          },
                          selectedIconColor: widget.selectedIconColor,
                          hoverColor: widget.hoverColor,
                          iconColor: widget.iconColor,
                          selectedTextColor: widget.selectedTextColor,
                          selectedColor: widget.selectedColor,
                          selectedTileColor: widget.selectedTileColor,
                          textColor: widget.textColor,
                          tileColor: widget.tileColor,
                        );
                      } else {
                        SideBarDivider divider =
                            widget.tiles?[index] as SideBarDivider;
                        return Divider(
                          height: divider.height,
                          endIndent: divider.endIndent,
                          indent: divider.indent,
                          thickness: divider.thickness,
                          color: divider.color,
                        );
                      }
                    },
                  ),
                if ((widget.bottomWidget?.scrollable ?? false) == true)
                  SizedBox(
                    height: widget.bottomWidget?.height,
                    child: widget.bottomWidget?.child,
                  ),
              ],
            ),
          ),
        ),
        const Spacer(),
        if (((widget.bottomWidget?.scrollable ?? false) == false) && showFull)
          SizedBox(
            height: widget.bottomWidget?.height,
            child: widget.bottomWidget?.child,
          ),
        if (((widget.bottomSmallWidget?.scrollable ?? false) == false) &&
            !showFull)
          SizedBox(
            height: widget.bottomSmallWidget?.height,
            child: widget.bottomSmallWidget?.child,
          ),
      ],
    );
  }

  double get getTilesHeight {
    if (showFull) {
      var scrolltype = getScrollableState(
        top: widget.topWidget?.scrollable ?? false,
        bottom: widget.bottomWidget?.scrollable ?? false,
      );
      switch (scrolltype) {
        case ScrollableDrawers.both:
          return widget.size.height;
        case ScrollableDrawers.topOnly:
          return widget.size.height - (widget.bottomWidget?.height ?? 0);
        case ScrollableDrawers.bottomOnly:
          return widget.size.height - (widget.topWidget?.height ?? 0);
        case ScrollableDrawers.none:
          return widget.size.height -
              ((widget.topWidget?.height ?? 0) +
                  (widget.bottomWidget?.height ?? 0));
        default:
          return 0;
      }
    } else {
      var scrolltype = getScrollableState(
        top: widget.topSmallWidget?.scrollable ?? false,
        bottom: widget.bottomSmallWidget?.scrollable ?? false,
      );
      switch (scrolltype) {
        case ScrollableDrawers.both:
          return widget.size.height;
        case ScrollableDrawers.topOnly:
          return widget.size.height - (widget.bottomSmallWidget?.height ?? 0);
        case ScrollableDrawers.bottomOnly:
          return widget.size.height - (widget.topSmallWidget?.height ?? 0);
        case ScrollableDrawers.none:
          return widget.size.height -
              ((widget.topSmallWidget?.height ?? 0) +
                  (widget.bottomSmallWidget?.height ?? 0));
        default:
          return 0;
      }
    }
  }

  ScrollableDrawers getScrollableState({
    required bool top,
    required bool bottom,
  }) {
    if (top && bottom) {
      return ScrollableDrawers.both;
    } else if (top) {
      return ScrollableDrawers.topOnly;
    } else if (bottom) {
      return ScrollableDrawers.bottomOnly;
    } else {
      return ScrollableDrawers.none;
    }
  }

  Widget? getTopWidget({required bool scrollBig, required bool scrollSmall}) {
    if (showFull && widget.topWidget != null) {
      if ((widget.topWidget!.scrollable) == scrollBig) {
        return SizedBox(
          height: widget.topWidget?.height,
          child: widget.topWidget?.child,
        );
      }
    } else {
      if (!showFull && widget.topSmallWidget != null) {
        if ((widget.topSmallWidget!.scrollable) == scrollSmall) {
          return SizedBox(
            height: widget.topSmallWidget?.height,
            child: widget.topSmallWidget?.child,
          );
        }
      }
    }
    return null;
  }
}

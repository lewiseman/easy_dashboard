import 'package:easy_dashboard/src/helper/easy_controller.dart';
import 'package:easy_dashboard/src/models/desktop_view_model.dart';
import 'package:easy_dashboard/src/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EasyDesktopLayout extends StatefulWidget {
  final EasyAppController controller;
  final Duration duration;
  final BoxConstraints constraints;
  final DrawerBuilder drawer;
  final Color backgroundColor;
  final Color sideBarColor;
  final double appBarHeight;
  final Icon navigationIcon;
  final DesktopView desktop;
  final List<Widget>? appBarActions;
  final double navigationIconSplashRadius;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final Color appBarColor;
  final bool centerTitle;
  const EasyDesktopLayout({
    Key? key,
    required this.controller,
    required this.duration,
    required this.constraints,
    required this.navigationIcon,
    required this.sideBarColor,
    this.appBarActions,
    required this.backgroundColor,
    required this.drawer,
    required this.navigationIconSplashRadius,
    required this.appBarHeight,
    required this.desktop,
    this.systemOverlayStyle,
    required this.appBarColor,
    required this.centerTitle,
  }) : super(key: key);

  @override
  State<EasyDesktopLayout> createState() => _EasyDesktopLayoutState();
}

class _EasyDesktopLayoutState extends State<EasyDesktopLayout> {
  late double sideBarPos = widget.desktop.sideBarWidth;
  bool opened = true;
  @override
  Widget build(BuildContext context) {
    if (widget.desktop.fullAppBar) {
      return Column(
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: widget.duration,
                height: widget.appBarHeight,
                width: widget.desktop.fullAppBar
                    ? widget.desktop.sideBarWidth
                    : opened
                        ? sideBarPos
                        : 0,
                decoration: BoxDecoration(
                  color: widget.desktop.fullAppBar
                      ? widget.appBarColor
                      : widget.sideBarColor,
                  border: Border(
                    right: widget.desktop.fullAppBar
                        ? BorderSide.none
                        : widget.desktop.border,
                    bottom: widget.desktop.fullAppBar
                        ? widget.desktop.border
                        : BorderSide.none,
                  ),
                ),
                child: Row(
                  children: [
                    if (widget.desktop.fullAppBar) navigationButton,
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: widget.appBarHeight,
                  width: widget.constraints.maxWidth - sideBarPos,
                  decoration: BoxDecoration(
                    color: widget.appBarColor,
                    border: Border(bottom: widget.desktop.border),
                  ),
                  child: Row(
                    children: [
                      widget.centerTitle ? const Spacer() : const SizedBox(),
                      AnimatedBuilder(
                        animation: widget.controller,
                        builder: (context, child) {
                          return widget.controller.page.title;
                        },
                      ),
                      Spacer(),
                      ...?widget.appBarActions,
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              AnimatedContainer(
                duration: widget.duration,
                width: opened ? sideBarPos : 0,
                height: widget.constraints.maxHeight - widget.appBarHeight,
                decoration: BoxDecoration(
                  color: widget.sideBarColor,
                  border: Border(right: widget.desktop.border),
                ),
                onEnd: () {
                  widget.controller.movingToFalse();
                },
                child: AnimatedBuilder(
                  animation: widget.controller,
                  builder: (context, child) {
                    return (sideBarPos == 0 || widget.controller.moving)
                        ? const SizedBox()
                        : widget.drawer(
                            Size(
                              sideBarPos,
                              widget.constraints.maxHeight -
                                  widget.appBarHeight,
                            ),
                            null,
                          );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  // width: opened
                  //     ? (widget.constraints.maxWidth - widget.smallSideBarWidth)
                  //     : widget.constraints.maxWidth,
                  height: widget.constraints.maxHeight - widget.appBarHeight,
                  color: widget.backgroundColor,
                  child: AnimatedBuilder(
                    animation: widget.controller,
                    builder: (context, child) {
                      return AnimatedSwitcher(
                        duration: widget.duration,
                        child: widget.controller.page.child,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          AnimatedContainer(
            duration: widget.duration,
            width: opened ? sideBarPos : 0,
            height: widget.constraints.maxHeight,
            decoration: BoxDecoration(
              color: widget.sideBarColor,
              border: Border(right: widget.desktop.border),
            ),
            onEnd: () {
              widget.controller.movingToFalse();
            },
            child: AnimatedBuilder(
              animation: widget.controller,
              builder: (context, child) {
                return (sideBarPos == 0 || widget.controller.moving)
                    ? const SizedBox()
                    : widget.drawer(
                        Size(
                          sideBarPos,
                          widget.constraints.maxHeight - widget.appBarHeight,
                        ),
                        null,
                      );
              },
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: widget.appBarHeight,
                  // width: widget.constraints.maxWidth - sideBarPos,
                  decoration: BoxDecoration(
                    color: widget.appBarColor,
                    border: Border(bottom: widget.desktop.border),
                  ),
                  child: Row(
                    children: [
                      navigationButton,
                      widget.centerTitle ? const Spacer() : const SizedBox(),
                      AnimatedBuilder(
                        animation: widget.controller,
                        builder: (context, child) {
                          return widget.controller.page.title;
                        },
                      ),
                      Spacer(),
                      ...?widget.appBarActions,
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: widget.constraints.maxWidth - sideBarPos,
                  height: widget.constraints.maxHeight - widget.appBarHeight,
                  color: widget.backgroundColor,
                  child: AnimatedBuilder(
                    animation: widget.controller,
                    builder: (context, child) {
                      return AnimatedSwitcher(
                        duration: widget.duration,
                        child: widget.controller.page.child,
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }
  }

  Widget get navigationButton {
    return IconButton(
      icon: widget.navigationIcon,
      splashRadius: widget.navigationIconSplashRadius,
      onPressed: () {
        toggle();
      },
    );
  }

  void toggle() {
    setState(() {
      if (sideBarPos == widget.desktop.sideBarWidth) {
        sideBarPos = widget.desktop.previewSize;
        opened = true;
      } else if (sideBarPos == widget.desktop.previewSize) {
        sideBarPos = 0;
        opened = false;
        widget.controller.movingToTrue();
      } else {
        sideBarPos = widget.desktop.sideBarWidth;
        opened = true;
        widget.controller.movingToTrue();
      }
    });
  }
}

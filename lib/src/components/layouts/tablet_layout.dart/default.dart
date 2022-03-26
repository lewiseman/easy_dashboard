import 'package:easy_dashboard/src/helper/easy_controller.dart';
import 'package:easy_dashboard/src/models/tablet_view_model.dart';
import 'package:easy_dashboard/src/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EasyTabletLayout extends StatefulWidget {
  final EasyAppController controller;
  final Duration duration;
  final BoxConstraints constraints;
  final DrawerBuilder drawer;
  final Color backgroundColor;
  final double appBarHeight;
  final Icon navigationIcon;
  final Color sideBarColor;
  final TabletView tablet;
  final List<Widget>? appBarActions;
  final double navigationIconSplashRadius;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final Color appBarColor;
  final bool centerTitle;
  const EasyTabletLayout({
    Key? key,
    required this.controller,
    required this.duration,
    required this.constraints,
    required this.navigationIcon,
    this.appBarActions,
    required this.sideBarColor,
    required this.backgroundColor,
    required this.drawer,
    required this.navigationIconSplashRadius,
    required this.appBarHeight,
    required this.tablet,
    this.systemOverlayStyle,
    required this.appBarColor,
    required this.centerTitle,
  }) : super(key: key);

  @override
  State<EasyTabletLayout> createState() => _EasyTabletLayoutState();
}

class _EasyTabletLayoutState extends State<EasyTabletLayout> {
  bool opened = true;
  bool moving = false;

  @override
  Widget build(BuildContext context) {
    if (widget.tablet.fullAppBar) {
      return Column(
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: widget.duration,
                width: widget.tablet.fullAppBar
                    ? widget.tablet.previewSize
                    : opened
                        ? widget.tablet.previewSize
                        : 0,
                height: widget.appBarHeight,
                decoration: BoxDecoration(
                  color: widget.tablet.fullAppBar
                      ? widget.appBarColor
                      : widget.sideBarColor,
                  border: Border(
                    right: widget.tablet.fullAppBar
                        ? BorderSide.none
                        : widget.tablet.border,
                    bottom: widget.tablet.fullAppBar
                        ? widget.tablet.border
                        : BorderSide.none,
                  ),
                ),
                child: Row(
                  children: [
                    if (widget.tablet.fullAppBar) navigationButton,
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  // width: widget.constraints.maxWidth - widget.smallSideBarWidth,
                  height: widget.appBarHeight,
                  decoration: BoxDecoration(
                    color: widget.appBarColor,
                    border: Border(bottom: widget.tablet.border),
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
              )
            ],
          ),
          Row(
            children: [
              AnimatedContainer(
                duration: widget.duration,
                width: opened ? widget.tablet.previewSize : 0,
                height: widget.constraints.maxHeight - widget.appBarHeight,
                decoration: BoxDecoration(
                  color: widget.sideBarColor,
                  border: Border(right: widget.tablet.border),
                ),
                onEnd: () {
                  widget.controller.movingToFalse();
                },
                child: AnimatedBuilder(
                  animation: widget.controller,
                  builder: (context, child) {
                    return (opened && !widget.controller.moving)
                        ? widget.drawer(
                            Size(
                              widget.tablet.previewSize,
                              widget.constraints.maxHeight -
                                  widget.appBarHeight,
                            ),
                            null,
                          )
                        : const SizedBox();
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
            width: opened ? widget.tablet.previewSize : 0,
            height: widget.constraints.maxHeight,
            decoration: BoxDecoration(
              color: widget.sideBarColor,
              border: Border(right: widget.tablet.border),
            ),
            onEnd: () {
              widget.controller.movingToFalse();
            },
            child: AnimatedBuilder(
              animation: widget.controller,
              builder: (context, child) {
                return (opened && !widget.controller.moving)
                    ? widget.drawer(
                        Size(
                          widget.tablet.previewSize,
                          widget.constraints.maxHeight - widget.appBarHeight,
                        ),
                        null,
                      )
                    : const SizedBox();
              },
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  // width: widget.constraints.maxWidth - widget.smallSideBarWidth,
                  height: widget.appBarHeight,
                  decoration: BoxDecoration(
                    color: widget.appBarColor,
                    border: Border(bottom: widget.tablet.border),
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
                  width: opened
                      ? (widget.constraints.maxWidth -
                          widget.tablet.previewSize)
                      : widget.constraints.maxWidth,
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
          ),
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
      opened = !opened;
    });
    widget.controller.movingToTrue();
  }
}

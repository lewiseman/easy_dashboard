import 'package:easy_dashboard/src/helper/easy_controller.dart';
import 'package:easy_dashboard/src/models/mobile_view_model.dart';
import 'package:easy_dashboard/src/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EasyMobileLayout extends StatefulWidget {
  final EasyAppController controller;
  final Duration duration;
  final BoxConstraints constraints;
  final MobileView mobile;
  final DrawerBuilder drawer;
  final Color backgroundColor;
  final Color sideBarColor;
  final double appBarHeight;
  final Icon navigationIcon;
  final List<Widget>? appBarActions;
  final double navigationIconSplashRadius;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final Color appBarColor;
  final bool centerTitle;
  const EasyMobileLayout({
    Key? key,
    required this.controller,
    required this.duration,
    required this.constraints,
    required this.mobile,
    required this.navigationIcon,
    this.appBarActions,
    required this.backgroundColor,
    required this.drawer,
    required this.sideBarColor,
    required this.navigationIconSplashRadius,
    required this.appBarHeight,
    this.systemOverlayStyle,
    required this.appBarColor,
    required this.centerTitle,
  }) : super(key: key);

  @override
  State<EasyMobileLayout> createState() => _EasyMobileLayoutState();
}

class _EasyMobileLayoutState extends State<EasyMobileLayout>
    with TickerProviderStateMixin {
  static const double widthGesture = 50.0;
  double _percent = 0.0;
  AnimationController? _animationDrawerController;
  late Animation _animation;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationDrawerController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation =
        Tween<double>(begin: 0, end: widget.mobile.sideBarOpenSize).animate(
      CurvedAnimation(
        parent: _animationDrawerController!,
        curve: Curves.decelerate,
        reverseCurve: Curves.decelerate,
      ),
    );
  }

  @override
  void dispose() {
    _animationDrawerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: widget.sideBarColor,
          width: widget.mobile.sideBarOpenSize,
          height: widget.constraints.maxHeight,
          child: widget.drawer(
            Size(widget.mobile.sideBarOpenSize, widget.constraints.maxHeight),
            null,
          ),
        ),
        AnimatedBuilder(
          animation: _animationDrawerController!,
          builder: (_, child) {
            return Transform.translate(
              offset: Offset(_animation.value, 0),
              child: child,
            );
          },
          child: GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onHorizontalDragStart: _onHorizontalDragStart,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            onHorizontalDragUpdate: (detail) =>
                _onHorizontalDragUpdate(detail, widget.constraints),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
              child: Column(
                children: <Widget>[
                  AppBar(
                    backgroundColor: widget.appBarColor,
                    centerTitle: widget.centerTitle,
                    elevation: widget.mobile.appBarElevation,
                    toolbarHeight: widget.appBarHeight,
                    leadingWidth: widget.mobile.appBarToolbarHeightLeadingWidth,
                    toolbarTextStyle: widget.mobile.toolbarTextStyle,
                    systemOverlayStyle: widget.systemOverlayStyle,
                    flexibleSpace: widget.mobile.appBarFlexibleSpace,
                    bottom: widget.mobile.appBarbottom,
                    actions: widget.appBarActions,
                    leading: IconButton(
                      splashRadius: widget.navigationIconSplashRadius,
                      icon: widget.navigationIcon,
                      onPressed: () => toggle(),
                    ),
                    title: AnimatedBuilder(
                      animation: widget.controller,
                      builder: (context, child) {
                        return widget.controller.page.title;
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topLeft,
                      color: widget.backgroundColor,
                      width: double.infinity,
                      child: AnimatedBuilder(
                        animation: widget.controller,
                        builder: (context, child) {
                          return widget.controller.page.child;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  bool get isDrawerOpen => _animationDrawerController!.isCompleted;
  AnimationController? get animationController => _animationDrawerController;

  void toggle() => _animationDrawerController!.isCompleted
      ? _animationDrawerController!.reverse()
      : _animationDrawerController!.forward();

  void openSlider() => _animationDrawerController!.forward();

  void closeSlider() => _animationDrawerController!.reverse();

  void _onHorizontalDragStart(DragStartDetails detail) {
    if (!widget.mobile.isDraggable) return;

    //Check use start dragging from left edge / right edge then enable dragging
    if ((detail.localPosition.dx <= widthGesture) ||
            (detail.localPosition.dx >=
                widthGesture) /*&&
        detail.localPosition.dy <= widget.appBarHeight*/
        ) {
      setState(() {
        _isDragging = true;
      });
    }
  }

  void _onHorizontalDragEnd(DragEndDetails detail) {
    if (!widget.mobile.isDraggable) return;
    if (_isDragging) {
      openOrClose();
      setState(() {
        _isDragging = false;
      });
    }
  }

  void _onHorizontalDragUpdate(
    DragUpdateDetails detail,
    BoxConstraints constraints,
  ) {
    if (!widget.mobile.isDraggable) return;
    // open drawer for left/right type drawer
    if (_isDragging) {
      var globalPosition = detail.globalPosition.dx;
      globalPosition = globalPosition < 0 ? 0 : globalPosition;
      double position = globalPosition / constraints.maxWidth;
      move(position);
    }

    // close drawer for left/right type drawer
    if (isDrawerOpen && detail.delta.dx < 15) {
      closeSlider();
    }
  }

  move(double percent) {
    _percent = percent;
    _animationDrawerController!.value = percent;
  }

  openOrClose() {
    if (_percent > 0.3) {
      openSlider();
    } else {
      closeSlider();
    }
  }
}

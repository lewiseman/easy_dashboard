import 'package:flutter/material.dart';

import 'models/general.dart';

enum _EasyDashboardSlot { body, appBar, drawer, endDrawer }

enum _DrawerOveride { none, minimised }

enum _EasyDashboardSize { phone, tablet, desktop }

class _EasyDashboardLayout extends MultiChildLayoutDelegate {
  final double navBreakpoint;
  final _EasyDashboardSize dashboardSize;
  final Size appBarSize;
  final bool extendedAppBar;
  final _DrawerOveride drawerOveride;
  final bool hoveringDrawer;
  final EasyDashBoardConstraints dashBoardConstraints;

  _EasyDashboardLayout({
    required this.navBreakpoint,
    required this.dashboardSize,
    required this.appBarSize,
    required this.extendedAppBar,
    required this.drawerOveride,
    required this.hoveringDrawer,
    required this.dashBoardConstraints,
  });

  @override
  void performLayout(Size size) {
    if (hasChild(_EasyDashboardSlot.appBar)) {
      final BoxConstraints appBarConstraints;
      final Offset positionOffset;
      if (dashboardSize == _EasyDashboardSize.phone) {
        appBarConstraints = BoxConstraints(
          maxHeight: appBarSize.height,
          maxWidth: size.width,
        );
        positionOffset = const Offset(0, 0);
      } else {
        appBarConstraints = BoxConstraints(
          maxHeight: appBarSize.height,
          maxWidth: extendedAppBar
              ? size.width
              : hoveringDrawer
                  ? appBarSize.width
                  : size.width - navBreakpoint,
        );
        positionOffset = positionOffset = Offset(
          extendedAppBar
              ? 0
              : hoveringDrawer
                  ? size.width - appBarSize.width
                  : navBreakpoint,
          0,
        );
      }
      layoutChild(_EasyDashboardSlot.appBar, appBarConstraints);
      positionChild(
        _EasyDashboardSlot.appBar,
        positionOffset,
      );
    }

    if (hasChild(_EasyDashboardSlot.body)) {
      final BoxConstraints bodyConstraints;
      final Offset positionOffset;
      if (dashboardSize == _EasyDashboardSize.phone) {
        bodyConstraints = BoxConstraints(
          maxHeight: size.height - appBarSize.height,
          maxWidth: size.width,
        );
        positionOffset = Offset(0, appBarSize.height);
      } else if (dashboardSize == _EasyDashboardSize.tablet) {
        bodyConstraints = BoxConstraints(
          maxHeight: size.height - appBarSize.height,
          maxWidth: hoveringDrawer
              ? size.width - dashBoardConstraints.tabletSideBarWidth
              : size.width - navBreakpoint,
        );
        positionOffset = Offset(
          hoveringDrawer
              ? dashBoardConstraints.tabletSideBarWidth.toDouble()
              : navBreakpoint,
          appBarSize.height,
        );
      } else {
        bodyConstraints = BoxConstraints(
          maxHeight: size.height - appBarSize.height,
          maxWidth: hoveringDrawer
              ? size.width - dashBoardConstraints.tabletSideBarWidth
              : size.width - navBreakpoint,
        );
        positionOffset = Offset(
            hoveringDrawer
                ? dashBoardConstraints.tabletSideBarWidth.toDouble()
                : navBreakpoint,
            appBarSize.height);
      }

      layoutChild(_EasyDashboardSlot.body, bodyConstraints);
      positionChild(_EasyDashboardSlot.body, positionOffset);
    }

    if (hasChild(_EasyDashboardSlot.drawer)) {
      final BoxConstraints drawerConstraints;
      final Offset drawerOffset;
      if (dashboardSize == _EasyDashboardSize.phone) {
        drawerConstraints = BoxConstraints.tight(size);
        drawerOffset = Offset.zero;
      } else {
        drawerConstraints = BoxConstraints(
          maxHeight:
              extendedAppBar ? size.height - appBarSize.height : size.height,
          maxWidth: navBreakpoint,
        );
        drawerOffset = Offset(0, extendedAppBar ? appBarSize.height : 0);
      }
      layoutChild(_EasyDashboardSlot.drawer, drawerConstraints);
      positionChild(_EasyDashboardSlot.drawer, drawerOffset);
    }

    if (hasChild(_EasyDashboardSlot.endDrawer)) {
      layoutChild(_EasyDashboardSlot.endDrawer, BoxConstraints.tight(size));
      positionChild(_EasyDashboardSlot.endDrawer, Offset.zero);
    }
  }

  @override
  bool shouldRelayout(covariant _EasyDashboardLayout oldDelegate) {
    return oldDelegate.navBreakpoint != navBreakpoint;
    // return true;
  }
}

class EasyDashboard extends StatefulWidget {
  final Color? backgroundColor;
  final Widget? body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final bool extendedAppBar;
  final EasyDashBoardConstraints dashBoardConstraints;
  final String? restorationId;
  const EasyDashboard({
    super.key,
    this.backgroundColor,
    this.body,
    this.appBar,
    this.drawer,
    this.endDrawer,
    this.extendedAppBar = false,
    this.dashBoardConstraints = const EasyDashBoardConstraints(),
    this.restorationId,
  });

  static EasyDashboardState of(BuildContext context) {
    final EasyDashboardState? result =
        context.findAncestorStateOfType<EasyDashboardState>();
    if (result != null) {
      return result;
    }
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'EasyDashboard.of() called with a context that does not contain a EasyDashboard.',
      ),
      context.describeElement('The context used was'),
    ]);
  }

  @override
  State<EasyDashboard> createState() => EasyDashboardState();
}

class EasyDashboardState extends State<EasyDashboard>
    with SingleTickerProviderStateMixin, RestorationMixin {
  final GlobalKey<DrawerControllerState> _drawerKey =
      GlobalKey<DrawerControllerState>();
  final GlobalKey<DrawerControllerState> _endDrawerKey =
      GlobalKey<DrawerControllerState>();

  final RestorableBool _drawerOpened = RestorableBool(false);
  final RestorableBool _endDrawerOpened = RestorableBool(false);

  late AnimationController _animationController;

  _EasyDashboardSize? _dashboardSize;
  double? navigationEndPoint;
  bool _hoverinDrawer = false;
  _DrawerOveride _drawerOveride = _DrawerOveride.none;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _animationController.addListener(_buildAnimation);
  }

  _buildAnimation() {
    setState(() {
      navigationEndPoint = _animationController.value *
          widget.dashBoardConstraints.desktopSideBarWidth;
    });
  }

  void drawerAction() {
    if (_dashboardSize == _EasyDashboardSize.phone) {
      _openDrawer();
    } else {
      if (_drawerOveride == _DrawerOveride.none) {
        _drawerOveride = _DrawerOveride.minimised;
        if (_dashboardSize == _EasyDashboardSize.tablet) {
          _animationController.animateTo(0);
        } else {
          goToHalf();
        }
      } else {
        _drawerOveride = _DrawerOveride.none;
        if (_dashboardSize == _EasyDashboardSize.tablet) {
          goToHalf();
        } else {
          _animationController.forward();
        }
      }
    }
  }

  void endDrawerAction() {
    if (_drawerKey.currentState != null && _drawerOpened.value) {
      _drawerKey.currentState!.close();
    }
    _endDrawerKey.currentState?.open();
  }

  void _openDrawer() {
    if (_endDrawerKey.currentState != null && _endDrawerOpened.value) {
      _endDrawerKey.currentState!.close();
    }
    _drawerKey.currentState?.open();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final ThemeData themeData = Theme.of(context);
    Size appBarSize = Size.zero;
    final List<LayoutId> children = <LayoutId>[];
    _EasyDashboardSize buildDashSize = _calDashboardSize(mediaQuery.size);
    _updateNavBreakPoint(buildDashSize);
    _dashboardSize = buildDashSize;

    if (widget.body != null) {
      children.add(
        LayoutId(id: _EasyDashboardSlot.body, child: widget.body!),
      );
    }

    if (widget.appBar != null) {
      appBarSize = Size(
        widget.extendedAppBar
            ? mediaQuery.size.width
            : mediaQuery.size.width -
                _calAppBarSizeNegation(
                  _dashboardSize!,
                  mediaQuery.size,
                ),
        widget.appBar!.preferredSize.height + mediaQuery.padding.top,
      );
      children.add(
        LayoutId(id: _EasyDashboardSlot.appBar, child: widget.appBar!),
      );
    }

    if (widget.drawer != null) {
      _buildDrawer(
        children,
      );
    }

    if (widget.endDrawer != null) {
      children.add(
        LayoutId(
          id: _EasyDashboardSlot.endDrawer,
          child: DrawerController(
            key: _endDrawerKey,
            alignment: DrawerAlignment.end,
            drawerCallback: _endDrawerOpenedCallback,
            isDrawerOpen: _endDrawerOpened.value,
            child: widget.endDrawer!,
          ),
        ),
      );
    }
    return Material(
      color: widget.backgroundColor ?? themeData.scaffoldBackgroundColor,
      child: CustomMultiChildLayout(
        delegate: _EasyDashboardLayout(
          extendedAppBar: widget.extendedAppBar,
          navBreakpoint:
              navigationEndPoint ?? _calcInitialNavBreakpoint(_dashboardSize!),
          dashboardSize: _dashboardSize!,
          drawerOveride: _drawerOveride,
          appBarSize: appBarSize,
          dashBoardConstraints: widget.dashBoardConstraints,
          hoveringDrawer: _hoverinDrawer,
        ),
        children: children,
      ),
    );
  }

  void _drawerOpenedCallback(bool isOpened) {
    if (_drawerOpened.value != isOpened) {
      setState(() {
        _drawerOpened.value = isOpened;
      });
    }
  }

  void _endDrawerOpenedCallback(bool isOpened) {
    if (_endDrawerOpened.value != isOpened) {
      setState(() {
        _endDrawerOpened.value = isOpened;
      });
    }
  }

  void _buildDrawer(List<LayoutId> children) {
    if (_dashboardSize == _EasyDashboardSize.phone) {
      children.add(
        LayoutId(
          id: _EasyDashboardSlot.drawer,
          child: DrawerController(
            key: _drawerKey,
            alignment: DrawerAlignment.start,
            drawerCallback: _drawerOpenedCallback,
            isDrawerOpen: _drawerOpened.value,
            child: widget.drawer!,
          ),
        ),
      );
    } else {
      children.add(
        LayoutId(
          id: _EasyDashboardSlot.drawer,
          child: (_dashboardSize == _EasyDashboardSize.tablet &&
                      _drawerOveride == _DrawerOveride.none) ||
                  (_dashboardSize == _EasyDashboardSize.desktop &&
                      _drawerOveride == _DrawerOveride.minimised)
              ? MouseRegion(
                  onEnter: (event) {
                    _hoverinDrawer = true;
                    _animationController.forward();
                  },
                  onExit: (event) {
                    goToHalf().then((value) => _hoverinDrawer = false);
                  },
                  child: widget.drawer!,
                )
              : widget.drawer!,
        ),
      );
    }
  }

  _updateNavBreakPoint(_EasyDashboardSize dsize) {
    if (_dashboardSize != null && _dashboardSize != dsize) {
      if (dsize == _EasyDashboardSize.tablet &&
          _dashboardSize == _EasyDashboardSize.desktop) {
        goToHalf();
      } else if (_dashboardSize == _EasyDashboardSize.tablet &&
          dsize == _EasyDashboardSize.desktop) {
        _animationController.forward();
      }
    }
  }

  Future<void> goToHalf() async {
    await _animationController.animateTo(
      widget.dashBoardConstraints.tabletSideBarWidth /
          widget.dashBoardConstraints.desktopSideBarWidth,
    );
  }

  num _calAppBarSizeNegation(_EasyDashboardSize dashtype, Size size) {
    bool minimized = (_drawerOveride == _DrawerOveride.minimised);
    switch (dashtype) {
      case _EasyDashboardSize.phone:
        return 0;
      case _EasyDashboardSize.tablet:
        return minimized ? 0 : widget.dashBoardConstraints.tabletSideBarWidth;
      default:
        return minimized
            ? widget.dashBoardConstraints.tabletSideBarWidth
            : widget.dashBoardConstraints.desktopSideBarWidth;
    }
  }

  _EasyDashboardSize _calDashboardSize(Size size) {
    final double width = size.width;
    if (width < widget.dashBoardConstraints.tabletBreakPoint) {
      return _EasyDashboardSize.phone;
    } else if (width >= widget.dashBoardConstraints.tabletBreakPoint &&
        width < widget.dashBoardConstraints.desktopBreakPoint) {
      return _EasyDashboardSize.tablet;
    } else {
      return _EasyDashboardSize.desktop;
    }
  }

  double _calcInitialNavBreakpoint(_EasyDashboardSize dashbdSize) {
    if (dashbdSize == _EasyDashboardSize.desktop) {
      navigationEndPoint =
          widget.dashBoardConstraints.desktopSideBarWidth.toDouble();
      _animationController.value = 1;
      return navigationEndPoint!;
    } else {
      navigationEndPoint =
          widget.dashBoardConstraints.tabletSideBarWidth.toDouble();
      _animationController.value =
          widget.dashBoardConstraints.tabletSideBarWidth /
              widget.dashBoardConstraints.desktopSideBarWidth;
      return navigationEndPoint!;
    }
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_drawerOpened, 'drawer_open');
    registerForRestoration(_endDrawerOpened, 'end_drawer_open');
  }
}

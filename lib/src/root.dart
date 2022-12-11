import 'package:easy_dashboard/src/models/general.dart';
import 'package:flutter/material.dart';

enum _EasyDashboardSlot { body, appBar, drawer, endDrawer }

enum _EasyDashboardSize { phone, tablet, desktop }

enum _DrawerOveride { none, minimised }

class _EasyDashboardLayout extends MultiChildLayoutDelegate {
  final _EasyDashboardSize dashboardSize;
  final TextDirection textDirection;
  final Size appBarSize;
  final bool hoveringDrawer;
  final bool extendedAppBar;
  final _DrawerOveride drawerOveride;
  final EasyDashBoardConstraints dashBoardConstraints;

  _EasyDashboardLayout({
    required this.dashboardSize,
    required this.dashBoardConstraints,
    required this.textDirection,
    required this.extendedAppBar,
    required this.appBarSize,
    required this.hoveringDrawer,
    required this.drawerOveride,
  });

  @override
  void performLayout(Size size) {
    final bool minimized = drawerOveride == _DrawerOveride.minimised;
    if (hasChild(_EasyDashboardSlot.appBar)) {
      final BoxConstraints appBarConstraints;
      appBarConstraints = BoxConstraints(
        maxHeight: appBarSize.height,
        maxWidth: appBarSize.width,
      );
      layoutChild(_EasyDashboardSlot.appBar, appBarConstraints);
      positionChild(
        _EasyDashboardSlot.appBar,
        Offset(
          size.width - appBarSize.width,
          0,
        ),
      );
    }

    if (hasChild(_EasyDashboardSlot.body)) {
      // print('object $dashboardSize  ${size.width}');
      final BoxConstraints bodyConstraints;
      final Offset positionOffset;
      if (dashboardSize == _EasyDashboardSize.phone) {
        bodyConstraints = BoxConstraints(
          maxHeight: size.height - appBarSize.height,
          maxWidth: size.width,
        );
        positionOffset = Offset(0.0, appBarSize.height);
      } else if (dashboardSize == _EasyDashboardSize.tablet) {
        bodyConstraints = BoxConstraints(
          maxHeight: size.height - appBarSize.height,
          maxWidth: minimized
              ? size.width
              : size.width - dashBoardConstraints.tabletSideBarWidth,
        );
        positionOffset = Offset(
          minimized ? 0 : dashBoardConstraints.tabletSideBarWidth.toDouble(),
          appBarSize.height,
        );
      } else {
        bodyConstraints = BoxConstraints(
          maxHeight: size.height - appBarSize.height,
          maxWidth: minimized
              ? size.width - dashBoardConstraints.tabletSideBarWidth
              : size.width - dashBoardConstraints.desktopSideBarWidth,
        );
        positionOffset = Offset(
          minimized
              ? dashBoardConstraints.tabletSideBarWidth.toDouble()
              : dashBoardConstraints.desktopSideBarWidth.toDouble(),
          appBarSize.height,
        );
      }

      layoutChild(_EasyDashboardSlot.body, bodyConstraints);
      positionChild(_EasyDashboardSlot.body, positionOffset);
    }

    if (hasChild(_EasyDashboardSlot.drawer)) {
      final BoxConstraints drawerConstraints;
      if (dashboardSize == _EasyDashboardSize.phone) {
        drawerConstraints = BoxConstraints.tight(size);
      } else if (dashboardSize == _EasyDashboardSize.tablet) {
        drawerConstraints = BoxConstraints(
          maxWidth: hoveringDrawer ?dashBoardConstraints.desktopSideBarWidth.toDouble() : dashBoardConstraints.tabletSideBarWidth.toDouble(),
          maxHeight: size.height,
        );
      } else {
        drawerConstraints = BoxConstraints(
          maxWidth: minimized && !hoveringDrawer
              ? dashBoardConstraints.tabletSideBarWidth.toDouble()
              : dashBoardConstraints.desktopSideBarWidth.toDouble(),
          // maxWidth: 10,
          maxHeight:
              extendedAppBar ? size.height - appBarSize.height : size.height,
        );
      }
      layoutChild(_EasyDashboardSlot.drawer, drawerConstraints);
      positionChild(
        _EasyDashboardSlot.drawer,
        Offset(0, extendedAppBar ? appBarSize.height : 0),
      );
    }

    if (hasChild(_EasyDashboardSlot.endDrawer)) {
      layoutChild(_EasyDashboardSlot.endDrawer, BoxConstraints.tight(size));
      positionChild(_EasyDashboardSlot.endDrawer, Offset.zero);
    }
  }

  @override
  bool shouldRelayout(_EasyDashboardLayout oldDelegate) {
    return oldDelegate.drawerOveride != drawerOveride ||
        oldDelegate.hoveringDrawer != hoveringDrawer;
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
    this.drawer,
    this.endDrawer,
    this.extendedAppBar = false,
    this.restorationId,
    this.appBar,
    this.dashBoardConstraints = const EasyDashBoardConstraints(),
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

class EasyDashboardState extends State<EasyDashboard> with RestorationMixin {
  final GlobalKey<DrawerControllerState> _drawerKey =
      GlobalKey<DrawerControllerState>();
  final GlobalKey<DrawerControllerState> _endDrawerKey =
      GlobalKey<DrawerControllerState>();

  final RestorableBool _drawerOpened = RestorableBool(false);
  final RestorableBool _endDrawerOpened = RestorableBool(false);
  _EasyDashboardSize? _dashboardSize;
  _DrawerOveride _drawerOveride = _DrawerOveride.none;
  bool _hoverinDrawer = false;

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

  void drawerAction() {
    if (_dashboardSize != null) {
      if (_dashboardSize == _EasyDashboardSize.phone) {
        _openDrawer();
      } else {
        setState(() {
          _drawerOveride = (_drawerOveride == _DrawerOveride.none)
              ? _DrawerOveride.minimised
              : _DrawerOveride.none;
        });
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
    final List<LayoutId> children = <LayoutId>[];
    final TextDirection textDirection = Directionality.of(context);

    _dashboardSize = _calDashboardSize(mediaQuery.size);

    Size appBarSize = Size.zero;

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
          dashboardSize: _dashboardSize!,
          drawerOveride: _drawerOveride,
          dashBoardConstraints: widget.dashBoardConstraints,
          textDirection: textDirection,
          hoveringDrawer: _hoverinDrawer,
          extendedAppBar: widget.extendedAppBar,
          appBarSize: appBarSize,
        ),
        children: children,
      ),
    );
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
    } else if (_dashboardSize == _EasyDashboardSize.tablet &&
        _drawerOveride == _DrawerOveride.minimised) {
      return;
    } else if ((_dashboardSize == _EasyDashboardSize.tablet &&
            _drawerOveride == _DrawerOveride.none) ||
        (_dashboardSize == _EasyDashboardSize.desktop &&
            _drawerOveride == _DrawerOveride.minimised)) {
      children.add(
        LayoutId(
          id: _EasyDashboardSlot.drawer,
          child: MouseRegion(
            onEnter: (event) {
              setState(() {
                _hoverinDrawer = true;
              });
            },
            onExit: (event) {
              setState(() {
                _hoverinDrawer = false;
              });
            },
            child: widget.drawer!,
          ),
        ),
      );
    } else {
      children.add(
        LayoutId(
          id: _EasyDashboardSlot.drawer,
          child: widget.drawer!,
        ),
      );
    }
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
    } else if (width > widget.dashBoardConstraints.tabletBreakPoint &&
        width < widget.dashBoardConstraints.desktopBreakPoint) {
      return _EasyDashboardSize.tablet;
    } else {
      return _EasyDashboardSize.desktop;
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

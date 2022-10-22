import 'package:easy_dashboard/src/components/dashboard.dart';
import 'package:easy_dashboard/src/components/layouts/desktop_layout/default.dart';
import 'package:easy_dashboard/src/components/layouts/flat_dashboard/root.dart';
import 'package:easy_dashboard/src/components/layouts/mobile_layout/default.dart';
import 'package:easy_dashboard/src/components/layouts/tablet_layout.dart/default.dart';
import 'package:easy_dashboard/src/helper/easy_controller.dart';
import 'package:easy_dashboard/src/models/body_model.dart';
import 'package:easy_dashboard/src/models/desktop_view_model.dart';
import 'package:easy_dashboard/src/models/mobile_view_model.dart';
import 'package:easy_dashboard/src/models/tablet_view_model.dart';
import 'package:easy_dashboard/src/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EasyDashboard extends StatelessWidget {
  /// Use [EasyController] to control the [EasyDashboard] body widget .
  ///  Use this to set the initial body widget.
  final EasyController controller;
  final EasyBody? body;

  /// The Duration of the animation when the [EasyDashboard] is opened or closed among others.
  final Duration duration;

  /// The pixels at which the ui breaks into the mobile view
  final double mobileBreakpoint;

  /// The pixels at which the ui breaks into the tablet view
  final double tabletBreakpoint;

  /// General background color of the [EasyDashboard]
  final Color backgroundColor;

  ///  Display properties while in tablet view such as dashboard style
  final MobileView mobileView;

  /// Display properties while in tablet view such as dashboard style
  final TabletView tabletView;

  /// Display properties while in desktop view such as dashboard style
  final DesktopView desktopView;

  /// An drawer widget that will be displayed on the left side of the [EasyDashboard].
  ///  You can use the pre-built [EasyDrawer] to create a faster easier drawer .
  final DrawerBuilder drawer;

  /// What to show when the tablet break point is reached,
  /// change it to override or persist a current view.
  /// Example:
  /// ```dart
  /// tabletMode = EasyDeviceMode.mobile
  /// tabletMode = EasyDeviceMode.desktop
  /// ```
  ///
  final EasyDeviceMode tabletMode;

  /// What to show when the mobile break point is reached,
  /// change it to override or persist a current view.
  /// Example:
  /// ```dart
  /// mobileMode = EasyDeviceMode.tablet
  /// mobileMode = EasyDeviceMode.desktop
  /// ```
  ///
  final EasyDeviceMode mobileMode;

  /// What to show when the desktop break point is reached,
  /// change it to override or persist a current view.
  /// Example:
  /// ```dart
  /// desktopMode = EasyDeviceMode.mobile
  /// desktopMode = EasyDeviceMode.tablet
  /// ```
  ///
  final EasyDeviceMode desktopMode;
  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// The height of the app bar
  final double appBarHeight;

  /// The icon that will control the responsive navigation of the [EasyDashboard]
  final Icon navigationIcon;

  /// Whether or not the appbar title is centered
  final bool centerTitle;

  /// The splash radius of the navigation icon when pressed
  final double navigationIconSplashRadius;

  /// The color of the app bar
  final Color appBarColor;

  /// The color of the sidebar navigation
  final Color sideBarColor;

  /// A list of Widgets for the [AppBar] actions
  final List<Widget>? appBarActions;
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// ## Easy Dashboard
  /// A simple yet powerful widget for creating fast Dashboards.
  ///
  const EasyDashboard({
    Key? key,
    required this.controller,
    this.body,
    this.duration = const Duration(milliseconds: 300),
    this.mobileBreakpoint = 600,
    this.tabletBreakpoint = 900,
    this.mobileView = const MobileView(),
    this.tabletView = const TabletView(),
    this.desktopView = const DesktopView(),
    this.tabletMode = EasyDeviceMode.tablet,
    this.mobileMode = EasyDeviceMode.mobile,
    this.desktopMode = EasyDeviceMode.desktop,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    this.systemOverlayStyle,
    this.floatingActionButtonAnimator,
    this.appBarHeight = kToolbarHeight,
    this.centerTitle = true,
    this.backgroundColor = Colors.white,
    this.navigationIcon = const Icon(Icons.menu),
    this.navigationIconSplashRadius = 20,
    this.appBarColor = Colors.blue,
    this.sideBarColor = Colors.white,
    this.appBarActions,
    required this.drawer,
  })  : assert(backgroundColor != Colors.transparent),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < mobileBreakpoint) {
            return getLayout(mobileMode, constraints);
          } else if (constraints.maxWidth < tabletBreakpoint) {
            return getLayout(tabletMode, constraints);
          } else {
            return getLayout(desktopMode, constraints);
          }
        },
      ),
    );
  }

  Widget getLayout(EasyDeviceMode mode, BoxConstraints constraints) {
    switch (mode) {
      case EasyDeviceMode.mobile:
        return EasyMobileLayout(
          controller: controller,
          backgroundColor: backgroundColor,
          drawer: drawer,
          appBarColor: appBarColor,
          mobile: mobileView,
          centerTitle: centerTitle,
          constraints: constraints,
          duration: duration,
          appBarHeight: appBarHeight,
          navigationIcon: navigationIcon,
          navigationIconSplashRadius: navigationIconSplashRadius,
          appBarActions: appBarActions,
          sideBarColor: sideBarColor,
        );
      case EasyDeviceMode.tablet:
        return EasyTabletLayout(
          controller: controller,
          backgroundColor: backgroundColor,
          drawer: drawer,
          appBarColor: appBarColor,
          sideBarColor: sideBarColor,
          centerTitle: centerTitle,
          constraints: constraints,
          duration: duration,
          tablet: tabletView,
          appBarHeight: appBarHeight,
          navigationIcon: navigationIcon,
          navigationIconSplashRadius: navigationIconSplashRadius,
          appBarActions: appBarActions,
        );
      case EasyDeviceMode.desktop:
        return EasyDesktopLayout(
          controller: controller,
          backgroundColor: backgroundColor,
          drawer: drawer,
          appBarColor: appBarColor,
          sideBarColor: sideBarColor,
          centerTitle: centerTitle,
          constraints: constraints,
          duration: duration,
          desktop: desktopView,
          appBarHeight: appBarHeight,
          navigationIcon: navigationIcon,
          navigationIconSplashRadius: navigationIconSplashRadius,
          appBarActions: appBarActions,
        );
      default:
        return const SizedBox();
    }
  }
}

class Easy extends DashBoard {
  /// Determines what dashboard to show . It is assigned at the end of each constructor .
  final EasyNavigationType type;

  const Easy.flat({
    Key? key,
    super.controller,
    super.fullAppBar = false,
    super.appBar,
    super.body = const SizedBox.shrink(),
    super.appBarHeight = kToolbarHeight,
    super.mobileBreakpoint = 600,
    super.tabletBreakpoint = 900,
  })  : type = EasyNavigationType.flatNavigation,
        super(key: key);

  @override
  Widget buildNavigation(BuildContext context, EasyController controller) {
    switch (type) {
      case EasyNavigationType.flatNavigation:
        return FlatNavigation(
          key: key,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    return Expanded(
      child: body,
    );
  }
}

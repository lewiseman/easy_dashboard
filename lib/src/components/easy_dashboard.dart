import 'package:easy_dashboard/src/components/layouts/desktop_layout/default.dart';
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
  final EasyAppController controller;
  final EasyBody? body;
  final Duration duration;
  final double mobileBreakpoint;
  final double tabletBreakpoint;
  final Color backgroundColor;
  final MobileView mobileView;
  final TabletView tabletView;
  final DesktopView desktopView;
  final DrawerBuilder drawer;
  final EasyDeviceMode tabletMode;
  final EasyDeviceMode mobileMode;
  final EasyDeviceMode desktopMode;
  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final double appBarHeight;
  final Icon navigationIcon;
  final bool centerTitle;
  final double navigationIconSplashRadius;
  final Color appBarColor;
  final Color sideBarColor;
  final List<Widget>? appBarActions;
  final SystemUiOverlayStyle? systemOverlayStyle;

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

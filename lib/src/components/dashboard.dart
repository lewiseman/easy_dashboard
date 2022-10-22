import 'package:easy_dashboard/src/helper/easy_controller.dart';
import 'package:flutter/material.dart';

abstract class DashBoard extends StatelessWidget {
  const DashBoard({
    super.key,
    this.controller,
    required this.fullAppBar,
    this.appBar,
    this.appBarHeight,
    required this.mobileBreakpoint,
    required this.tabletBreakpoint,
    required this.body,
  }) : assert(
          fullAppBar == true ? appBar != null : true,
          'appBar must be provided when fullAppBar is true',
        );
  final EasyController? controller;
  final bool fullAppBar;
  final PreferredSizeWidget? appBar;
  final double? appBarHeight;
  final double mobileBreakpoint;
  final double tabletBreakpoint;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    Widget navigation =
        buildNavigation(context, controller ?? EasyController());
    Widget content = buildBody(context);
    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < mobileBreakpoint) {
            return Text('Mobile');
          } else if (constraints.maxWidth < tabletBreakpoint) {
            return Text('Tablet');
          }
          return layout(
            context: context,
            navigation: navigation,
            body: content,
            size: Size(constraints.maxWidth, constraints.maxHeight),
          );
        },
      ),
    );
  }

  Widget layout({
    required BuildContext context,
    required Widget navigation,
    required Widget body,
    required Size size,
  }) {
       return Text('data');
    // if (fullAppBar) {
      // return Scaffold(
          // appBar: appBar,
          // body: Row(
          // children: [navigation, body],
          // ),
          // );
          // Column(
          //   children: [
          //     appBar ??SizedBox.shrink(),
          //     Row(
          //       children: [
          //         Expanded(
          //           child: navigation,
          //         ),
          //       ],
          //     )
          //   ],
          // );
    // }
 
    // return Row(
    //   children: [
    //     navigation,
    //     SizedBox(
    //       height: size.width,
    //       child: Column(
    //         children: [
    //           SizedBox(
    //             height: appBarHeight ?? 0,
    //             child: appBar ?? SizedBox.shrink(),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }

  /// Subclasses should override this method to build the specific navigation .
  @protected
  Widget buildNavigation(BuildContext context, EasyController controller);

  /// Subclasses should override this method for the body .
  @protected
  Widget buildBody(BuildContext context);
}

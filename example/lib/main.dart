import 'package:easy_dashboard/easy_dashboard.dart';
import 'package:example/temp.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashBoard(),
    );
  }
}

class DashBoard extends StatelessWidget {
  DashBoard({Key? key}) : super(key: key);
  late final EasyAppController controller = EasyAppController(
    intialBody: EasyBody(child: tile1.body, title: tile1.title),
  );

 
  @override
  Widget build(BuildContext context) {
    return EasyDashboard(
      controller: controller,
      navigationIcon: const Icon(Icons.menu, color: Colors.white),
      appBarActions: actions,
      centerTitle: true,
      appBarColor: Colors.teal,
      sideBarColor: Colors.grey.shade100,
      tabletView: const TabletView(
        fullAppBar: false,
        border: BorderSide(width: 0.5, color: Colors.grey),
      ),
      desktopView: const DesktopView(
        fullAppBar: true,
        border: BorderSide(width: 0.5, color: Colors.grey),
      ),
      drawer: (Size size, Widget? child) {
        return EasyDrawer(
          iconColor: Colors.teal,
          hoverColor: Colors.grey.shade300,
          tileColor: Colors.grey.shade100,
          selectedColor: Colors.black.withGreen(80),
          selectedIconColor: const Color.fromARGB(255, 2, 105, 95),
          textColor: Colors.black.withGreen(20),
          selectedTileColor: const Color(0XFFC0C5CA),
          tiles: tiles,
          topWidget: SideBox(
            scrollable: true,
            height: 150,
            child: topOpenWidget,
          ),
          bottomWidget: SideBox(
            scrollable: false,
            height: 50,
            child: bottomOpenWidget,
          ),
          bottomSmallWidget: SideBox(
            height: 50,
            child: bottomSmallWidget,
          ),
          topSmallWidget: SideBox(
            height: 50,
            child: topSmallWidget,
          ),
          size: size,
          onTileTapped: (body) {
            controller.switchBody(body);
          },
        );
      },
    );
  }
}

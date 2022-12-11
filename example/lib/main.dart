import 'package:flutter/material.dart';
import 'package:easy_dashboard/easy_dashboard.dart';

void main() {
  runApp(const ExapleApp());
}

class ExapleApp extends StatelessWidget {
  const ExapleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        //  EasyDashboard(
        //   extendedAppBar: false,
        //   appBar: AppBar(
        //     elevation: 0,
        //     title: Text('Easy Dashboard'),
        //     leading: Builder(builder: (context) {
        //       return IconButton(
        //         onPressed: () {
        //           EasyDashboard.of(context).drawerAction();
        //         },
        //         icon: Icon(Icons.menu),
        //       );
        //     }),
        //     actions: [
        //       Builder(builder: (context) {
        //         return IconButton(
        //           onPressed: () {
        //             EasyDashboard.of(context).endDrawerAction();
        //           },
        //           icon: Icon(Icons.settings),
        //         );
        //       })
        //     ],
        //   ),
        //   drawer: Drawer(
        //     backgroundColor: Colors.black,
        //   ),
        //   endDrawer: Drawer(),
        //   body: Container(
        //     color: Colors.red,
        //     child: Center(
        //       child: Text('Center'),
        //     ),
        //   ),
        // );
        // EasyDashboard2();
        EasyDashboard(
      extendedAppBar: true,
      appBar: AppBar(
        elevation: 0,
        title: Text('Easy Dashboard'),
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              EasyDashboard.of(context).drawerAction();
            },
            icon: Icon(Icons.menu),
          );
        }),
        actions: [
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                EasyDashboard.of(context).endDrawerAction();
              },
              icon: Icon(Icons.settings),
            );
          })
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
      ),
      endDrawer: Drawer(),
      body: Container(
        color: Colors.red,
        child: Center(
          child: Text('Center'),
        ),
      ),
    );
  }
}

import 'package:easy_dashboard/easy_dashboard.dart';
import 'package:flutter/material.dart';

class FlatExample extends StatelessWidget {
  const FlatExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Easy.flat(
      appBar: AppBar(
        title: Text('Flat Example'),
      ),
      fullAppBar: false,
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EDrawer extends StatelessWidget {
  final bool isExpanded;
  const EDrawer({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: CupertinoScrollbar(
        child: ListView(
          children: [..._head, ..._body, ..._foot],
        ),
      ),
    );
  }

  List<Widget> get _head {
    return [
      if (isExpanded)
        ListTile(
          leading: CircleAvatar(),
          title: Text('Lewis Mbiuki'),
          onTap: () {},
        )
      else
        ListTile(
          leading: CircleAvatar(),
          onTap: () {},
        )
    ];
  }

  List<Widget> get _body {
    return [
      if (isExpanded)
        ListTile(
          leading: CircleAvatar(),
          title: Text('Lewis Mbiuki'),
        )
      else
        ListTile(
          leading: CircleAvatar(),
        )
    ];
  }

  List<Widget> get _foot {
    return [
      if (isExpanded)
        ListTile(
          leading: CircleAvatar(),
          title: Text('Lewis Mbiuki'),
        )
      else
        ListTile(
          leading: CircleAvatar(),
        )
    ];
  }
}

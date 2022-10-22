import 'package:flutter/material.dart';

class FlatNavigation extends StatelessWidget {
  const FlatNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          right: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
      ),
      child: Scrollbar(
        thumbVisibility: true,
        child: ListView(
          padding: EdgeInsets.only(left: 10, right: 10),
          children: [
            Material(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: () {},
                hoverColor: Colors.blue.withOpacity(.5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.home),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Home'),
                    ],
                  ),
                ),
              ),
            ),
            Material(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: () {},
                hoverColor: Colors.blue.withOpacity(.5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.landscape_sharp),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Mountains'),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: false,
                child: Row(
              children: [
                Container(
                  width: 1,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.red),
                ),
                Column(
                  children: [
                    Text('data'),
                    Text('data'),
                    Text('data'),
                    Text('data'),
                    Text('data'),
                  ],
                )
              ],
            )),
            Material(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: () {},
                hoverColor: Colors.blue.withOpacity(.5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.landscape_sharp),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Mountains'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

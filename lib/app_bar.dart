import 'package:flutter/material.dart';

class DevTrackerAppBar extends StatefulWidget implements PreferredSizeWidget{

  DevTrackerAppBar({Key key}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key : key);

  @override
  State<StatefulWidget> createState() {
    return _DevTrackerAppBarState();
  }

  @override
  final Size preferredSize;

}

class _DevTrackerAppBarState extends State<DevTrackerAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("DevTracker"),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.autorenew),
          onPressed: (){
            _refreshPressed();
          },
        ),
        IconButton(
          icon: Icon(Icons.build),
          onPressed: (){
            _settingsPressed();
          },
        )
      ],
    );
  }

  void _refreshPressed(){

  }

  void _settingsPressed(){

  }

}

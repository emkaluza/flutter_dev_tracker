import 'package:flutter/material.dart';
import 'package:flutter_dev_tracker/settings_screen.dart';

class DevTrackerAppBar extends StatefulWidget implements PreferredSizeWidget{

  DevTrackerAppBar(this._onPreferencesChanged, this._onRefreshPressed, {Key key}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key : key);

  @override
  State<StatefulWidget> createState() {
    return _DevTrackerAppBarState();
  }

  @override
  final Size preferredSize;
  final void Function() _onRefreshPressed;
  final void Function() _onPreferencesChanged;

}

class _DevTrackerAppBarState extends State<DevTrackerAppBar> {
  @override
  Widget build(BuildContext context) {

    var modalRoute = ModalRoute.of(context);

    return AppBar(
      title: const Text("DevTracker"),
      centerTitle: true,
      actions: <Widget>[
        modalRoute.settings.name.compareTo("/") == 1 ?
        IconButton(
          icon: Icon(Icons.autorenew),
          onPressed: (){
            // ignore: unnecessary_statements
            widget._onRefreshPressed;
          },
        ) : Container(),
        IconButton(
          icon: Icon(Icons.build),
          onPressed: (){
            _handleSettingsScreen();
          },
        )
      ],
    );
  }

  void _handleSettingsScreen() async {
    final result =  await Navigator.push(context, MaterialPageRoute(builder: (context){
      return SettingsScreen();
    }));
    if(result != null && result) {
      // ignore: unnecessary_statements
      widget._onPreferencesChanged;
    }
  }

}

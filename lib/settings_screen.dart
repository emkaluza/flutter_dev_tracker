import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SwitchListTile(
          onChanged: (_value){

          },
          value: true,
          title: const Text("Automatic login"),
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: "Host"
          ),
          initialValue: "host form preferences",
          validator: (_value){

          },
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: "Port"
          ),
          initialValue: "port from preferences",
          validator: (_value){

          },
        )
      ],
    );
  }

}
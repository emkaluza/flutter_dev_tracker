import 'package:flutter/material.dart';
import 'package:flutter_dev_tracker/utils/app_preferences.dart';

class SettingsScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            onChanged: (_value){
              AppPreferences.appPreferences.setBool(AppPreferences.AUTOMATIC_LOGIN_KEY, _value);
            },
            value: AppPreferences.appPreferences.getBool(AppPreferences.AUTOMATIC_LOGIN_KEY),
            title: const Text("Automatic login"),
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: "Host"
            ),
            initialValue: AppPreferences.appPreferences.getString(AppPreferences.HOST),
            onChanged: (_value){
                AppPreferences.appPreferences.setString(
                    _value, AppPreferences.HOST);
            },
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: "Port"
            ),
            initialValue: AppPreferences.appPreferences.getInt(AppPreferences.PORT).toString(),
            onChanged: (_value){
                AppPreferences.appPreferences.setInt(
                    AppPreferences.PORT, int.parse(_value));
            },
          )
        ],
      )
    );
  }

}
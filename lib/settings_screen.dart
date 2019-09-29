import 'package:flutter/material.dart';
import 'package:flutter_dev_tracker/utils/app_preferences.dart';

class SettingsScreen extends StatefulWidget {

  SettingsScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {

  static final _formKey = GlobalKey<FormState>();
  final TextEditingController _hostController = new TextEditingController(
    text: AppPreferences.appPreferences.getString(AppPreferences.HOST)
  );
  final TextEditingController _portController = new TextEditingController(
    text: AppPreferences.appPreferences.getInt(AppPreferences.PORT).toString()
  );
  bool _automaticLogin = AppPreferences.appPreferences.getBool(AppPreferences.AUTOMATIC_LOGIN_KEY);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: <Widget>[
            FlatButton(
              child: const Text("Update preferences"),
              onPressed: (){
                if(_formKey.currentState.validate()){
                  AppPreferences.appPreferences.setString(AppPreferences.HOST,
                      _hostController.text);
                  AppPreferences.appPreferences.setInt(
                      AppPreferences.PORT, int.parse(_portController.text));
                  AppPreferences.appPreferences.setBool(AppPreferences.AUTOMATIC_LOGIN_KEY, _automaticLogin);
                  Navigator.pop(context, true);
                }
              },
            ),
            Form(
              key: _formKey,
              child:           ListView(
                shrinkWrap: true,//otherwise cannot use list view in a column
                children: <Widget>[
                  SwitchListTile(
                    value: _automaticLogin,
                    title: const Text("Automatic login"),
                    onChanged: (_value){
                      setState(() {
                        _automaticLogin = _value;
                      });
                    },
                  ),
                  TextFormField(
                    controller: _hostController,
                    decoration: InputDecoration(
                        labelText: "Host"
                    ),
                    //initialValue: AppPreferences.appPreferences.getString(AppPreferences.HOST),
                    validator: (_value){
                      if(_value == null || _value.isEmpty) {
                        return "Cannot be null/empty";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _portController,
                    decoration: InputDecoration(
                        labelText: "Port"
                    ),
//                    initialValue: AppPreferences.appPreferences.getInt(AppPreferences.PORT).toString(),
                    validator: (_value){
                      if(_value == null || _value.isEmpty) {
                        return "Cannot be null/empty";
                      }
                      if(_value.contains(RegExp("\\D"))){
                        return "Only numbers allowed";
                      }
                      return null;
                    },
                  )
                ],
              ),
            ),
          ],
        )
    );
  }

}
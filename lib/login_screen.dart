import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }

}

class _LoginScreenState extends State<LoginScreen> {

  static const String _AUTOMATIC_LOGIN_KEY = "automaticLoggin";
  static const String _USER_NAME = "userName";
  static const String _USER_PASSWORD = "userPassword";

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //set default values for screen controls
  bool _automaticLogin = false;
  String _userName = "";
  String _userPassword = "";
  //fields
  TextField _userNameField;
  TextField _passwordField;
  Checkbox _automaticLoginCB;
  final SnackBar _loginInProgressSnackBar = SnackBar(
    content: Text("Loging in..."),
    duration: Duration(),
  );

  bool _isLoggingInProgress = false;



  @override
  void initState() {
    super.initState();
    _initFromPreferences();
  }

  @override
  Widget build(BuildContext context) {
    _userNameField = TextField(
      decoration: InputDecoration(
          hintText: "Login"
      ),
      controller: TextEditingController(text: _userName),
      onChanged: (text) => _userName = _userNameField.controller.text,
    );

    _passwordField = TextField(
      decoration: InputDecoration(
          hintText: "Password"
      ),
      controller: TextEditingController(text: _userPassword),
      onChanged: (text) => _userPassword = _passwordField.controller.text,
      obscureText: true,
    );

    _automaticLoginCB = Checkbox(
      value: _automaticLogin,
      onChanged: (bool updated){
        setState(() {
          _automaticLogin = updated;
        });
      },
    );

    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          margin: EdgeInsets.all(20.0),
          child: AbsorbPointer(
            absorbing: _isLoggingInProgress,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset("images/logo.jpeg",
                  height: 100,
                  width: 100,),
                _userNameField,
                _passwordField,
                SizedBox(
                  child: FlatButton(
                    child: Text("Login"),
                    onPressed: () {
                      _updateLoginPreferences();
                      _scaffoldKey.currentState.showSnackBar(_loginInProgressSnackBar);
                      setState(() {
                        _isLoggingInProgress = true;
                      });
                    },
                  ),
                  width: double.infinity,
                ),
                Row(
                  children: <Widget>[
                    Text("Login automatically"),
                    _automaticLoginCB,
                  ],
                )
              ],
            ),
          ),
        )
    );
  }

  _initFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _automaticLogin = prefs.containsKey(_AUTOMATIC_LOGIN_KEY) ? prefs.getBool(_AUTOMATIC_LOGIN_KEY) : false;
      //@TODO: password encoding!
      _userName = prefs.getString(_USER_NAME) ?? "";
      _userPassword = prefs.getString(_USER_PASSWORD) ?? "";
    });
  }

  _updateLoginPreferences() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_AUTOMATIC_LOGIN_KEY, _automaticLoginCB.value);
    prefs.setString(_USER_NAME, _automaticLoginCB.value ? _userName : "");
    prefs.setString(_USER_PASSWORD, _automaticLoginCB.value ? _userPassword : "");
  }
}
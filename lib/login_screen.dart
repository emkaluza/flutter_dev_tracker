import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dev_tracker/app_bar.dart';
import 'package:flutter_dev_tracker/utils/app_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }

}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final _formKey = GlobalKey<FormState>();

  //set default values for screen controls
  bool _automaticLogin = true;
  String _userName = "";
  String _userPassword = "";
  //fields
  TextFormField _userNameField;
  TextFormField _passwordField;

  bool _isLoggingInProgress = false;



  @override
  void initState() {
    super.initState();
    _initFromPreferences();
    if(_userName.isNotEmpty && _userPassword.isNotEmpty && _automaticLogin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {_makeAuthRequest();});
    }
  }

  @override
  Widget build(BuildContext context) {
    _userNameField = TextFormField(
      decoration: InputDecoration(
          hintText: "Login"
      ),
      controller: TextEditingController(text: _userName),
      onChanged: (text) => _userName = _userNameField.controller.text,
      onTap: (){
        final _controller = _userNameField.controller;
        _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      },
      textCapitalization: TextCapitalization.none,
      validator: (_value){
        if(_value.isEmpty) {
          return "Username required";
        }
        return null;
      },
    );

    _passwordField = TextFormField(
      decoration: InputDecoration(
          hintText: "Password"
      ),
      controller: TextEditingController(text: _userPassword),
      onChanged: (text) => _userPassword = _passwordField.controller.text,
      onTap: (){
        final _controller = _passwordField.controller;
        _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      },
      textCapitalization: TextCapitalization.none,
      obscureText: true,
      validator: (_value){
        if(_value.isEmpty) {
          return "Password required";
        }
        return null;
      },
    );

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        appBar: DevTrackerAppBar(_initFromPreferences(), (){}),
        body: Container(
          margin: EdgeInsets.all(20.0),
          child: AbsorbPointer(
            absorbing: _isLoggingInProgress,
            child: Form(
              key: _formKey,
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
                        if(!_formKey.currentState.validate()){
                          return;
                        }
                        _makeAuthRequest();
                        FocusScope.of(context).requestFocus(new FocusNode());//close soft keyboard
                        setState(() {
                          _isLoggingInProgress = true;
                        });
                      },
                    ),
                    width: double.infinity,
                  ),
                ],
              ),
            )
          ),
        )
    );
  }

  _initFromPreferences() {
    setState(() {
      _automaticLogin = AppPreferences.appPreferences.containsKey(AppPreferences.AUTOMATIC_LOGIN_KEY) ? AppPreferences.appPreferences.getBool(AppPreferences.AUTOMATIC_LOGIN_KEY) : false;
      //@TODO: password encoding!
      _userName = AppPreferences.appPreferences.getString(AppPreferences.USER_NAME) ?? "";
      _userPassword = AppPreferences.appPreferences.getString(AppPreferences.USER_PASSWORD) ?? "";
    });
  }

  _updateLoginPreferences()
  {
    AppPreferences.appPreferences.setBool(AppPreferences.AUTOMATIC_LOGIN_KEY, _automaticLogin);
    AppPreferences.appPreferences.setString(AppPreferences.USER_NAME, _automaticLogin ? _userName : "");
    AppPreferences.appPreferences.setString(AppPreferences.USER_PASSWORD, _automaticLogin ? _userPassword : "");
  }

  _showSnackBar(final String message, final bool showProgressIndicator, {Duration duration = const Duration(hours: 1)}) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Row(
        children: <Widget>[
          Visibility(
            child: CircularProgressIndicator(),
            visible: showProgressIndicator,
          ),
          Text(message),
        ],
      ),
      duration: duration,
    ));
  }

  _hideSnackBar(SnackBarClosedReason reason) {
    _scaffoldKey.currentState.hideCurrentSnackBar(reason: reason);
  }

  _makeAuthRequest() async {
    _updateLoginPreferences();
    var host = AppPreferences.appPreferences.getString(AppPreferences.HOST);
    var port = AppPreferences.appPreferences.getInt(AppPreferences.PORT);
    Map<String, String> headers = {"Content-type": "application/json"};

    _showSnackBar("Logging in...", true);
    final post = await http.post("$host:$port/auth", headers: headers, body: '{"username":"$_userName","password":"$_userPassword"}')
        .timeout(Duration(seconds: 10))
        .then((_v) {
      _hideSnackBar(SnackBarClosedReason.dismiss);
      _showSnackBar("Login succesful", false,duration: Duration(seconds: 3));
      setState(() {
        _isLoggingInProgress = false;
      });
    }, onError: (error){
      _hideSnackBar(SnackBarClosedReason.dismiss);
      _showSnackBar("Login failed, try again", false,duration: Duration(seconds: 3));
      setState(() {
        _isLoggingInProgress = false;
      });
    });


  }
}
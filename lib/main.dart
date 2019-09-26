// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_dev_tracker/utils/app_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

void main() async {
  await AppPreferences.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      title: "Cognitran Dev-Tracker",
      routes: {
        '/' : (context) => LoginScreen(),
        '/tracker' : (context) => null,
      },
    );
  }
}
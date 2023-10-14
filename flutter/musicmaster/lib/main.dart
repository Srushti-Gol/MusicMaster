import 'package:flutter/material.dart';
import 'package:musicmaster/screens/signin_screen.dart';
import 'package:musicmaster/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  dynamic user;
  if (token != null) {
    user = jsonDecode(token); 
  }
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: token != null ? HomeScreen(user: user) : SignInScreen(),
  ));
}

import 'package:alaev/wrappers/profile_wrapper.dart';
import 'package:flutter/material.dart';

import './screens/home_screen.dart';
import './screens/login_screen.dart';
import './screens/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color.fromRGBO(60, 42, 152, 1),
        accentColor: Color.fromRGBO(238, 124, 0, 1),
      ),
      home: HomeScreen(),
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        ProfileWrapper.routeName: (context) => ProfileWrapper(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
      },
    );
  }
}

import 'package:alaev/providers/auth.dart';
import 'package:alaev/screens/add_new_adv_screen.dart';
import 'package:alaev/wrappers/profile_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';
import './screens/login_screen.dart';
import './screens/register_screen.dart';
import './screens/company_adv_screen.dart';
import './screens/cv_screen.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Alaev',
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
          CompanyAdvertisement.routeName: (context) => CompanyAdvertisement(),
          AddNewAdvScreen.routeName: (context) => AddNewAdvScreen(),
        },
      ),
    );
  }
}

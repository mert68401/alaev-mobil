import 'package:alaev/providers/auth.dart';
import 'package:alaev/screens/company_adv/add_new_company_adv_screen.dart';
import 'package:alaev/screens/company_adv/my_company_advs_screen.dart';
import 'package:alaev/screens/job_adv/add_new_job_adv_screen.dart';
import 'package:alaev/screens/forgot_password_screen.dart';
import 'package:alaev/screens/job_adv/job_adv_detail_screen.dart';
import 'package:alaev/screens/job_adv/my_job_advs_screen.dart';
import 'package:alaev/wrappers/profile_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';
import './screens/login_screen.dart';
import './screens/register_screen.dart';
import 'screens/company_adv/company_adv_detail_screen.dart';
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
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Alaev',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Color.fromRGBO(60, 42, 152, 1),
            accentColor: Color.fromRGBO(238, 124, 0, 1),
          ),
          home: auth.isAuth
              ? HomeScreen(
                  loggedIn: true,
                )
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResult) =>
                      authResult.connectionState == ConnectionState.waiting
                          ? HomeScreen(loggedIn: true)
                          : HomeScreen(loggedIn: false)),
          routes: {
            LoginScreen.routeName: (context) => LoginScreen(),
            ProfileWrapper.routeName: (context) => ProfileWrapper(),
            RegisterScreen.routeName: (context) => RegisterScreen(),
            CompanyAdvertisement.routeName: (context) => CompanyAdvertisement(),
            AddNewCompanyAdvScreen.routeName: (context) => AddNewCompanyAdvScreen(),
            JobAdvertisement.routeName: (context) => JobAdvertisement(),
            AddNewJobAdvScreen.routeName: (context) => AddNewJobAdvScreen(),
            CvScreen.routeName: (context) => CvScreen(),
            ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
            MyCompanyAdvsScreen.routeName: (context) => MyCompanyAdvsScreen(),
            MyJobAdvsScreen.routeName: (context) => MyJobAdvsScreen()
          },
        ),
      ),
    );
  }
}

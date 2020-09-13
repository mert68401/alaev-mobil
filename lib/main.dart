import 'package:alaev/providers/auth.dart';
import 'package:alaev/push_nofitications.dart';
import 'package:alaev/screens/about_screen.dart';
import 'package:alaev/screens/chronology_screen.dart';
import 'package:alaev/screens/company_adv/add_new_company_adv_screen.dart';
import 'package:alaev/screens/company_adv/edit_my_company_advs_screen.dart';
import 'package:alaev/screens/company_adv/my_company_advs_screen.dart';
import 'package:alaev/screens/company_detail_screen.dart';
import 'package:alaev/screens/company_list_screen.dart';
import 'package:alaev/screens/founding_members_screen.dart';
import 'package:alaev/screens/job_adv/add_new_job_adv_screen.dart';
import 'package:alaev/screens/forgot_password_screen.dart';
import 'package:alaev/screens/job_adv/applied_user_job_adv_cv_screen.dart';
import 'package:alaev/screens/job_adv/applied_user_job_adv_screen.dart';
import 'package:alaev/screens/job_adv/edit_my_job_advs_screen.dart';
import 'package:alaev/screens/job_adv/job_adv_detail_screen.dart';
import 'package:alaev/screens/job_adv/my_job_advs_screen.dart';
import 'package:alaev/screens/members_screen.dart';
import 'package:alaev/screens/news_detail_screen.dart';
import 'package:alaev/wrappers/news_wrapper.dart';

import 'package:alaev/wrappers/profile_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './screens/home_screen.dart';
import './screens/login_screen.dart';
import './screens/register_screen.dart';
import 'screens/company_adv/company_adv_detail_screen.dart';
import './screens/cv_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PushNotificationsManager().init();
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
          localizationsDelegates: [
            // ... app-specific localization delegate[s] here
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''), // English, no country code
            const Locale('tr'), // Turkish, no country code
          ],
          debugShowCheckedModeBanner: false,
          title: 'Alaev',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Color.fromRGBO(60, 42, 152, 1),
            accentColor: Color.fromRGBO(238, 124, 0, 1),
            iconTheme: IconThemeData(
              color: Color.fromRGBO(60, 42, 152, 1), //change your color here
            ),
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
            HomeScreen.routeName: (context) => HomeScreen(loggedIn: auth.isAuth ? true : false),
            LoginScreen.routeName: (context) => LoginScreen(),
            ProfileWrapper.routeName: (context) => ProfileWrapper(),
            RegisterScreen.routeName: (context) => RegisterScreen(),
            CompanyAdvertisement.routeName: (context) => CompanyAdvertisement(),
            AddNewCompanyAdvScreen.routeName: (context) =>
                AddNewCompanyAdvScreen(),
            JobAdvertisement.routeName: (context) => JobAdvertisement(),
            AddNewJobAdvScreen.routeName: (context) => AddNewJobAdvScreen(),
            CvScreen.routeName: (context) => CvScreen(),
            ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
            MyCompanyAdvsScreen.routeName: (context) => MyCompanyAdvsScreen(),
            MyJobAdvsScreen.routeName: (context) => MyJobAdvsScreen(),
            NewsWrapper.routeName: (context) => NewsWrapper(),
            NewsDetailScreen.routeName: (context) => NewsDetailScreen(),
            EditMyJobAdvScreen.routeName: (context) => EditMyJobAdvScreen(),
            EditMyCompanyAdvScreen.routeName: (context) =>
                EditMyCompanyAdvScreen(),
            AppliedUsersJobAdvScreen.routeName: (context) =>
                AppliedUsersJobAdvScreen(),
            AppliedUserJobAdvCvScreen.routeName: (context) =>
                AppliedUserJobAdvCvScreen(),
            AboutScreen.routeName: (context) => AboutScreen(),
            MembersScreen.routeName: (context) => MembersScreen(),
            FoundingMembersScreen.routeName: (context) =>
                FoundingMembersScreen(),
            ChronologyScreen.routeName: (context) => ChronologyScreen(),
            CompanyListScreen.routeName: (context) => CompanyListScreen(),
            CompanyDetailScreen.routeName: (context) => CompanyDetailScreen(),
          },
        ),
      ),
    );
  }
}

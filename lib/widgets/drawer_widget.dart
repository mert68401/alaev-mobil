import 'package:alaev/screens/company_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:alaev/screens/user_list_screen.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void customLaunch(command) async {
      if (await canLaunch(command)) {
        await launch(command);
      } else {
        print(' could not launch $command');
      }
    }

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Drawer(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        './assets/images/alaevLogoClean.png',
                        fit: BoxFit.cover,
                        height: 120,
                      ),
                    ],
                  ),
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     Navigator.of(context)
              //         .pushReplacementNamed(HomeScreen.routeName);
              //   },
              //   child: ListTile(
              //     dense: true,
              //     title: Text("Anasayfa", style: TextStyle(fontSize: 13)),
              //     trailing: Icon(Icons.person),
              //   ),
              // ),
              InkWell(
                onTap: () {
                  customLaunch('http://alaev.org.tr');
                },
                child: ListTile(
                  dense: true,
                  title: Text(
                    "Web Sitemiz",
                    style: TextStyle(fontSize: 13),
                  ),
                  trailing: FaIcon(
                    FontAwesomeIcons.globe,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(CompanyListScreen.routeName);
                },
                child: ListTile(
                  dense: true,
                  title: Text(
                    "Anlaşmalı Kurumlar",
                    style: TextStyle(fontSize: 13),
                  ),
                  trailing: FaIcon(
                    FontAwesomeIcons.percentage,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(UserListScreen.routeName);
                },
                child: ListTile(
                  dense: true,
                  title: Text("Üyelerimiz", style: TextStyle(fontSize: 13)),
                  trailing: FaIcon(
                    FontAwesomeIcons.list,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  customLaunch('https://www.wiki.com.tr/');
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Powered By',
                        style: TextStyle(fontSize: 10),
                      ),
                      ClipRect(
                        child: Image.asset(
                          'assets/images/wikilogo.png',
                          height: 80,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

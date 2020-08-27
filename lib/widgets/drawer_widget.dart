import 'package:alaev/screens/about_screen.dart';
import 'package:alaev/screens/founding_members_screen.dart';
import 'package:alaev/screens/members_screen.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
            physics: NeverScrollableScrollPhysics(),
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
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(AboutScreen.routeName);
                },
                child: ListTile(
                  dense: true,
                  title: Text("Hakkımızda", style: TextStyle(fontSize: 13)),
                  trailing: Icon(Icons.person, size: 15),
                ),
              ),
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
                  trailing: Icon(
                    Icons.web_asset,
                    size: 15,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(MembersScreen.routeName);
                },
                child: ListTile(
                  dense: true,
                  title: Text("Kurullarımız", style: TextStyle(fontSize: 13)),
                  trailing: Icon(Icons.group),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(FoundingMembersScreen.routeName);
                },
                child: ListTile(
                  dense: true,
                  title: Text("Kurucu Mütevelliler",
                      style: TextStyle(fontSize: 13)),
                  trailing: Icon(Icons.group),
                ),
              ),
              InkWell(
                onTap: () {
                  customLaunch('http://alaev.org.tr/burslarimiz');
                },
                child: ListTile(
                  dense: true,
                  title:
                      Text("Burs Başvuruları", style: TextStyle(fontSize: 13)),
                  trailing: Icon(Icons.school),
                ),
              ),
              InkWell(
                onTap: () {
                  customLaunch('http://alaev.org.tr/iletisim');
                },
                child: ListTile(
                  dense: true,
                  title: Text("İletişim", style: TextStyle(fontSize: 13)),
                  trailing: Icon(Icons.mail),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Powered By',
                    style: TextStyle(fontSize: 10),
                  ),
                 
                  ClipRect(

                    child: Image.asset('assets/images/wikilogo.png',height: 100,),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

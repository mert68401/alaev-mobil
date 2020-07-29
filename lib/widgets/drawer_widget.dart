import 'package:alaev/screens/about_screen.dart';
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
      child: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
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
              onTap: () async {
                print("click");
                var result = await BarcodeScanner.scan();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Barcodun içeriği"),
                      content: Text(
                        result.rawContent,
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Kapat"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  },
                );
              },
              child: ListTile(
                title: Text("QR Code okuyucu"),
                trailing: Icon(Icons.camera_alt),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(AboutScreen.routeName);
              },
              child: ListTile(
                title: Text("Hakkımızda"),
                trailing: Icon(Icons.person),
              ),
            ),
            InkWell(
              onTap: () {
                customLaunch('http:alaev.org.tr/burslarimiz');
              },
              child: ListTile(
                title: Text("Burs Başvuruları"),
                trailing: Icon(Icons.school),
              ),
            ),
            InkWell(
              onTap: () {
                customLaunch('http:alaev.org.tr');
              },
              child: ListTile(
                title: Text("Web Sitemiz"),
                trailing: Icon(Icons.web_asset),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

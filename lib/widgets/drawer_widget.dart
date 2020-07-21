import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              onTap: () {},
              child: ListTile(
                title: Text("Hakkımızda"),
                trailing: Icon(Icons.person),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyAdvertisement extends StatelessWidget {
  static const routeName = '/company-adv-page';

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    String clickableCompanyNumber = arguments['companyNumber'];
    String clickablePersonalNumber = arguments['personalNumber'];

    void customLaunch(command) async {
      if (await canLaunch(command)) {
        await launch(command);
      } else {
        print(' could not launch $command');
      }
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
          ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              "./assets/images/alaevLogoClean.png",
              scale: 11,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                width: double.infinity - 1,
                child: arguments['imageUrl'].toString().length > 1
                    ? Image.network(
                        arguments['imageUrl'],
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        "https://www.9minecraft.net/wp-content/plugins/accelerated-mobile-pages/images/SD-default-image.png",
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  arguments['title'],
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        customLaunch('tel:$clickableCompanyNumber');
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.phone),
                          Text(
                            arguments['companyNumber'],
                            style: TextStyle(
                              color: Colors.indigo[800],
                            ),
                          )
                        ],
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        customLaunch('tel:$clickablePersonalNumber');
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.phone_android),
                          Text(
                            arguments['personalNumber'],
                            style: TextStyle(color: Colors.indigo[800]),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.mail),
                  Text(
                    arguments['email'],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                alignment: Alignment.centerLeft,
                child: Text(
                  arguments['content'],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
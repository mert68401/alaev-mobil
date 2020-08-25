import 'package:alaev/functions/functions.dart';
import 'package:alaev/functions/requests.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JobAdvertisement extends StatefulWidget {
  static const routeName = '/job-adv-page';

  @override
  _JobAdvertisementState createState() => _JobAdvertisementState();
}

class _JobAdvertisementState extends State<JobAdvertisement> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    String clickableCompanyNumber = arguments['companyNumber'];
    String clickablePersonalNumber = arguments['personalNumber'];
    String jobAdId = arguments['_id'];

    void customLaunch(command) async {
      if (await canLaunch(command)) {
        await launch(command);
      } else {
        print(' could not launch $command');
      }
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Text("Başvur"),
        onPressed: () {
          getUserRole().then((role) {
            role == "Kurumsal"
                ? showToastError(
                    'Kurumsal tip kullanıcılar iş başvurusu yapamaz!')
                : applyJobRequest(jobAdId: jobAdId);
          });
        },
      ),
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
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Container(
                height: 150,
                width: double.infinity,
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
                height: 20,
              ),
              Container(
                child: Text(
                  arguments['title'],
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        customLaunch('tel:$clickableCompanyNumber');
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.phone),
                          Text(
                            arguments['companyNumber'],
                            style: TextStyle(color: Colors.indigo[800]),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
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
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.mail),
                      Text(
                        arguments['email'],
                      )
                    ],
                  ),
                  Row(children: <Widget>[
                    Icon(Icons.library_books),
                    Text(
                      arguments['diploma'],
                    ),
                  ]),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.fiber_manual_record),
                  Text(
                    arguments['type'],
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
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

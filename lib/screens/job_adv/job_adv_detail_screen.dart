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
    print(arguments);

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
            print(role);
            role == "firma"
                ? showToastError(
                    'Firma tipi kullanıcılar iş başvurusu yapamaz!')
                : applyJobRequest(jobAdId: jobAdId);
          });
        },
      ),
      appBar: AppBar(
        title: Text('İlan Ayrıntıları'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(width: 10),
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
                    Row(
                      children: <Widget>[
                        Icon(Icons.mail),
                        Text(
                          arguments['email'],
                        )
                      ],
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
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

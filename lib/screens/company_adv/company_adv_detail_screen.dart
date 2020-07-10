import 'package:flutter/material.dart';

class CompanyAdvertisement extends StatelessWidget {
  static const routeName = '/company-adv-page';

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    print(arguments);
    return Scaffold(
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
                height: 200,
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
                    Row(
                      children: <Widget>[
                        Icon(Icons.phone),
                        Text(
                          arguments['companyNumber'],
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.phone_android),
                        Text(
                          arguments['personalNumber'],
                        )
                      ],
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

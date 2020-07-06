import 'package:alaev/screens/job_adv/add_new_job_adv_screen.dart';
import 'package:alaev/screens/job_adv/job_adv_screen.dart';
import 'package:flutter/material.dart';

class JobAdvertisementWrapper extends StatelessWidget {
  final List<Map<String, String>> advList = [
    {
      'title': 'İş İlanı Adı',
      'imageUrl': 'assets/images/logo.jpg',
      'subTitle': 'İş İlanı Adı Kısa açıklama'
    },
    {
      'title': 'İş İlanı Adı',
      'imageUrl': 'assets/images/logo.jpg',
      'subTitle':
          'İş İlanı Adı Kısa açıklama'
    },
    {
      'title': 'İş İlanı Adı',
      'imageUrl': 'assets/images/logo.jpg',
      'subTitle':
          'İş İlanı Adı Kısa açıklama'
    }
  ];
  
  void _pushNamedPage(context, routeName) {
    Navigator.of(context).pushNamed(routeName);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () =>
                  _pushNamedPage(context, AddNewJobAdvScreen.routeName)),
        ],
        title: Text('İş İlanları'),
      ),
      body: Container(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: advList.length,
          itemBuilder: (BuildContext context, int i) {
            return InkWell(
              onTap: () =>
                  _pushNamedPage(context, JobAdvertisement.routeName),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                margin: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(15),
                              ),
                              child: Image.asset(
                                advList[i]['imageUrl'],
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 20,
                          right: 10,
                          child: Container(
                            width: 270,
                            color: Colors.black54,
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 20,
                            ),
                            child: Text(
                              advList[i]['title'],
                              style: TextStyle(
                                fontSize: 26,
                                color: Colors.white,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              advList[i]
                                  ['subTitle'], //.substring(0, 95) + '...',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              maxLines: 3,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

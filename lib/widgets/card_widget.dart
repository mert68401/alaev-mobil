import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardWidget extends StatelessWidget {
  final dynamic onRefresh;
  final List items;
  final String routeName;
  final bool isFirebase;
  final bool isMyPage;
  final bool isMyJobPage;
  final f = new DateFormat('yyyy-MM-dd hh:mm');
  CardWidget({
    @required this.onRefresh,
    @required this.items,
    this.routeName,
    @required this.isFirebase,
    @required this.isMyPage,
    this.isMyJobPage,
  });

  Widget firebaseCheck(i) {
    if (!isFirebase) {
      print("asd");
      if (items[i]['imageUrl'].length > 1) {
        return Image.network(
          "http://statik.wiki.com.tr/assets/alaev/img/" + items[i]['imageUrl'],
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      } else {
        return Image.asset(
          './assets/images/logo.jpg',
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      }
    } else {
      if (items[i]['imageUrl'].length > 1) {
        return Image.network(
          items[i]['imageUrl'],
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      } else {
        return Image.asset(
          './assets/images/logo.jpg',
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      }
    }
  }

  Widget appliedUsersButton(BuildContext context, String a, int i) {
    print(a);
    if (isMyPage == false) {
      return SizedBox(height: 0);
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Stack(alignment: Alignment.bottomRight, children: <Widget>[
            Container(
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(50)),
              margin: EdgeInsets.only(top: 15, right: 15),
              child: IconButton(
                  icon: Icon(
                    Icons.view_list,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(routeName, arguments: {
                      "_id": items[i]["_id"],
                      "appliedUsers": items[i]["appliedUsers"],
                    });
                  }),
            ),
            Container(
                height: 23,
                width: 23,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25), color: Colors.red),
                margin: EdgeInsets.only(
                  right: 16,
                ),
                child: Text(
                  a,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ))
          ]),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Container(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int i) {
            return Stack(children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(routeName, arguments: {
                    "_id": items[i]["_id"],
                    "title": items[i]["title"],
                    "content": items[i]["content"],
                    "imageUrl": items[i]['imageUrl'].isNotEmpty
                        ? items[i]['imageUrl']
                        : '',
                    "personalNumber": items[i]["personalNumber"] != null &&
                            items[i]["personalNumber"].isNotEmpty
                        ? items[i]["personalNumber"]
                        : "",
                    "companyNumber": items[i]["companyNumber"] != null &&
                            items[i]["companyNumber"].isNotEmpty
                        ? items[i]["companyNumber"]
                        : "",
                    "email": items[i]["email"] != null &&
                            items[i]["email"].isNotEmpty
                        ? items[i]["email"]
                        : "",
                  });
                },
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
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: firebaseCheck(i),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(
                                    items[i]
                                        ['title'], //.substring(0, 95) + '...',
                                    style: TextStyle(fontSize: 15),
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    overflow: TextOverflow.fade,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: items[i]['createdAt'] != null &&
                                            items[i]['createdAt'].length > 1
                                        ? Text(
                                            f.format(DateTime.parse(
                                                items[i]['createdAt'])),
                                            textAlign: TextAlign.end,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              items[i]['appliedUsers'] == null
                  ? SizedBox(height: 0)
                  : appliedUsersButton(
                      context, items[i]['appliedUsers'].length.toString(), i),
            ]);
          },
        ),
      ),
    );
  }
}

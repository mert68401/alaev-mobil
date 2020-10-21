import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CardWidget extends StatelessWidget {
  final dynamic onRefresh;
  final List items;
  final String routeName;
  final bool isFirebase;
  final bool isMyPage;
  final bool isMyJobPage;
  final bool isJobPage;
  final String appliedRouteName;
  final f = new DateFormat('yyyy-MM-dd hh:mm');
  CardWidget(
      {@required this.onRefresh,
      @required this.items,
      this.routeName,
      @required this.isFirebase,
      @required this.isMyPage,
      this.isMyJobPage,
      this.appliedRouteName,
      @required this.isJobPage});

  Widget firebaseCheck(i) {
    if (!isFirebase) {
      if (items[i]['imageUrl'].length > 1) {
        return Image.network(
          "http://statik.wiki.com.tr/assets/alaev/img/" + items[i]['imageUrl'],
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 250,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                ),
              ),
            );
          },
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
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 250,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                ),
              ),
            );
          },
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
                    Navigator.of(context)
                        .pushNamed(appliedRouteName, arguments: {
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
    if (items.length == 0) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FaIcon(
              FontAwesomeIcons.dizzy,
              size: 50,
            ),
            Text("Burda bir şey yok."),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: isJobPage ? () => onRefresh("Hepsi", "Hepsi") : onRefresh,
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
                    "diploma": items[i]["diploma"] != null &&
                            items[i]["diploma"].isNotEmpty
                        ? items[i]["diploma"]
                        : "",
                    "type":
                        items[i]["type"] != null && items[i]["type"].isNotEmpty
                            ? items[i]["type"]
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

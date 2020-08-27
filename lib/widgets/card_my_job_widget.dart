import 'package:flutter/material.dart';

class MyCardJobWidget extends StatelessWidget {
  final bool isFirebase;
  final List items;
  final String routeName;
  final dynamic onRefresh;
  final String appliedRouteName;

  MyCardJobWidget(
      {@required this.isFirebase,
      @required this.items,
      this.routeName,
      this.appliedRouteName,
      @required this.onRefresh});

  Widget firebaseCheck(i) {
    if (!isFirebase) {
      if (items[i]['imageUrl'].length > 1) {
        return Image.network(
          "http://statik.wiki.com.tr/assets/alaev/img/" + items[i]['imageUrl'],
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 70,
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
          height: 70,
          width: 70,
          fit: BoxFit.cover,
        );
      } else {
        return Image.asset(
          './assets/images/logo.jpg',
          height: 70,
          width: 70,
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
              height: 70,
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
          height: 70,
          width: 70,
          fit: BoxFit.cover,
        );
      } else {
        return Image.asset(
          './assets/images/logo.jpg',
          height: 70,
          width: 70,
          fit: BoxFit.cover,
        );
      }
    }
  }

  Widget appliedUsersButton(BuildContext context, String a, int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Stack(alignment: Alignment.bottomRight, children: <Widget>[
          Container(
            width: 40,
            decoration: BoxDecoration(
                color: Colors.black87, borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.symmetric(vertical: 8),
            child: IconButton(
                icon: Icon(
                  Icons.view_list,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(appliedRouteName, arguments: {
                    "_id": items[i]["_id"],
                    "appliedUsers": items[i]["appliedUsers"],
                  });
                }),
          ),
          Container(
              height: 21,
              width: 21,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), color: Colors.red),
              margin: EdgeInsets.only(
                right: 0, bottom: 8
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
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            maxRadius: 25,
                            minRadius: 15,
                            child: firebaseCheck(i),
                          ),
                          title: Text(items[i]['title']),
                          subtitle: items[i]['companyName'] == null
                              ? SizedBox(height: 0)
                              : Text(items[i]['companyName']),
                          trailing: CircleAvatar(
                            backgroundColor: Colors.white,
                            maxRadius: 30,
                            child: items[i]['appliedUsers'] == null
                                ? SizedBox(height: 0)
                                : appliedUsersButton(
                                    context,
                                    items[i]['appliedUsers'].length.toString(),
                                    i),
                          )),
                    ],
                  ),
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}

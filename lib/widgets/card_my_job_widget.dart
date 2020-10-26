import 'package:alaev/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyCardJobWidget extends StatelessWidget {
  final List items;
  final String routeName;
  final dynamic onRefresh;
  final String appliedRouteName;

  MyCardJobWidget(
      {@required this.items,
      this.routeName,
      this.appliedRouteName,
      @required this.onRefresh});

  Widget appliedUsersButton(BuildContext context, String a, int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Stack(alignment: Alignment.bottomRight, children: <Widget>[
          Container(
            width: 50,
            decoration: BoxDecoration(
                color: Colors.black87, borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.symmetric(vertical: 5),
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
              margin: EdgeInsets.only(right: 0, bottom: 0),
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
      onRefresh: onRefresh,
      child: Container(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int i) {
            return Stack(children: <Widget>[
              InkWell(
                onTap: () {
                  showToastSuccessLong(
                      "İlanı düzenlemeniz durumunda ilan yeniden inaktif duruma gelir.");
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
                    "companyNumber": items[i]["companyNumber"] != null
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

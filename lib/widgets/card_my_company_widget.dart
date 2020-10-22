import 'package:alaev/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class MyCardCompanyWidget extends StatelessWidget {
  final List items;
  final String routeName;
  final dynamic onRefresh;
  final String appliedRouteName;
  final f = new DateFormat('yyyy-MM-dd');

  MyCardCompanyWidget(
      {
      @required this.items,
      this.routeName,
      this.appliedRouteName,
      @required this.onRefresh});

  
  @override
  Widget build(BuildContext context) {
    if (items.length == 0) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[FaIcon(
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
                          maxRadius: 40,
                          minRadius: 30,
                          child: null,
                        ),
                        title: Text(items[i]['title']),
                        subtitle: Text(items[i]['companyName'] != null
                            ? items[i]['companyName']
                            : ''),
                        trailing: Text(
                          items[i]['createdAt'] != null
                              ? f.format(DateTime.parse(items[i]['createdAt']))
                              : '',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
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

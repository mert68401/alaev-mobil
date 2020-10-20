import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardUserListWidget extends StatelessWidget {
  final List items;
  final String routeName;
  final dynamic onRefresh;
  final String appliedRouteName;
  final f = new DateFormat('yyyy-MM-dd');

  CardUserListWidget(
      {@required this.items,
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
          children: <Widget>[
            Text(
              "",
              style: TextStyle(color: Colors.grey),
            ),
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
                  Navigator.of(context).pushNamed(routeName, arguments: {
                    "_id": items[i]["_id"],
                    "fullName": items[i]["fullName"],
                    "phone": items[i]["phone"] != null &&
                                items[i]["phone"].isNotEmpty &&
                                items[i]["showPhone"] == "true" ||
                            items[i]["showPhone"] == true
                        ? items[i]["phone"]
                        : "",
                    "university": items[i]["university"] != null &&
                            items[i]["university"].isNotEmpty
                        ? items[i]["university"]
                        : "",
                    "universityFaculty":
                        items[i]["universityFaculty"] != null &&
                                items[i]["universityFaculty"].isNotEmpty
                            ? items[i]["universityFaculty"]
                            : "",
                    "city":
                        items[i]["city"] != null && items[i]["city"].isNotEmpty
                            ? items[i]["city"]
                            : "",
                    "graduateYear": items[i]["graduateYear"] != null &&
                            items[i]["graduateYear"].isNotEmpty
                        ? items[i]["graduateYear"]
                        : "",
                    "companyName": items[i]["companyName"] != null &&
                            items[i]["companyName"].isNotEmpty
                        ? items[i]["companyName"]
                        : "",
                    "job": items[i]["job"] != null && items[i]["job"].isNotEmpty
                        ? items[i]["job"]
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
                        title: Text(items[i]['fullName']),
                        subtitle: Text(items[i]['graduateYear'] != null
                            ? items[i]['graduateYear']
                            : ''),
                        trailing: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          child: Text(
                            items[i]['job'] != null ? items[i]['job'] : '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            textAlign: TextAlign.right,
                          ),
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

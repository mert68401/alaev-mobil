import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CardJobWidget extends StatelessWidget {
  final List items;
  final String routeName;
  final dynamic onRefresh;
  final String appliedRouteName;
  final f = new DateFormat('yyyy-MM-dd');

  CardJobWidget(
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
            var color;
            Color getColor() {
              if (items[i]["jobAdType"] == 'Diğer') {
                color = Colors.blue[200];
                return color;
              } else if (items[i]["jobAdType"] == 'Hizmet') {
                color = Colors.purple[200];
                return color;
              } else if (items[i]["jobAdType"] == 'Bilişim') {
                color = Colors.deepOrangeAccent[200];
                return color;
              } else if (items[i]["jobAdType"] == 'Gıda') {
                color = Colors.pink[200];
                return color;
              } else if (items[i]["jobAdType"] == 'Sağlık') {
                color = Colors.red[200];
                return color;
              } else if (items[i]["jobAdType"] == 'Ticaret') {
                color = Colors.cyan[200];
                return color;
              } else if (items[i]["jobAdType"] == 'Yapı') {
                color = Colors.greenAccent[200];
                return color;
              } else if (items[i]["jobAdType"] == 'Otomotiv') {
                color = Colors.indigo[200];
                return color;
              } else if (items[i]["jobAdType"] == 'Eğitim') {
                color = Colors.limeAccent[200];
                return color;
              } else if (items[i]["jobAdType"] == 'Tekstil') {
                color = Colors.teal[200];
                return color;
              }
            }

            Widget jobIcon() {
              if (items[i]["jobAdType"] == 'Diğer') {
                return FaIcon(FontAwesomeIcons.briefcase,
                    color: Colors.blue[200]);
              } else if (items[i]["jobAdType"] == 'Hizmet') {
                return FaIcon(FontAwesomeIcons.box, color: Colors.purple[200]);
              } else if (items[i]["jobAdType"] == 'Bilişim') {
                return FaIcon(FontAwesomeIcons.server,
                    color: Colors.deepOrangeAccent[200]);
              } else if (items[i]["jobAdType"] == 'Gıda') {
                return FaIcon(FontAwesomeIcons.utensils,
                    color: Colors.pink[200]);
              } else if (items[i]["jobAdType"] == 'Sağlık') {
                return FaIcon(FontAwesomeIcons.firstAid,
                    color: Colors.red[200]);
              } else if (items[i]["jobAdType"] == 'Ticaret') {
                return FaIcon(FontAwesomeIcons.moneyBillWaveAlt,
                    color: Colors.cyan[200]);
              } else if (items[i]["jobAdType"] == 'Yapı') {
                return FaIcon(FontAwesomeIcons.city,
                    color: Colors.greenAccent[200]);
              } else if (items[i]["jobAdType"] == 'Otomotiv') {
                return FaIcon(FontAwesomeIcons.car, color: Colors.indigo[200]);
              } else if (items[i]["jobAdType"] == 'Eğitim') {
                return FaIcon(FontAwesomeIcons.graduationCap,
                    color: Colors.limeAccent[200]);
              } else if (items[i]["jobAdType"] == 'Tekstil') {
                return FaIcon(FontAwesomeIcons.tshirt, color: Colors.teal[200]);
              }
            }

            return Stack(children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(routeName, arguments: {
                    "_id": items[i]["_id"],
                    "title": items[i]["title"],
                    "content": items[i]["content"],
                    "jobType": items[i]["jobType"],
                    "fullName": items[i]["fullName"],
                    "companyName": items[i]["companyName"] != null &&
                            items[i]["companyName"].isNotEmpty
                        ? items[i]["companyName"]
                        : "",
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
                    "city":
                        items[i]["city"] != null && items[i]["city"].isNotEmpty
                            ? items[i]["city"]
                            : "",
                  });
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: getColor(),
                          width: 2.0,
                          style: BorderStyle.solid),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            maxRadius: 30,
                            minRadius: 00,
                            child: jobIcon(),
                          ),
                          title: Text(items[i]['title']),
                          subtitle: Text(items[i]['companyName'] != null
                              ? items[i]['companyName']
                              : ''),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                items[i]['jobType'],
                                style:
                                    TextStyle(color: Colors.grey[800], fontSize: 13),
                              ),
                              Text(
                                f.format(DateTime.parse(items[i]['createdAt'])),
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

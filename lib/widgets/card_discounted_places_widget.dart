import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CardDiscountedPlaces extends StatelessWidget {
  final List items;
  final String routeName;
  final dynamic onRefresh;
  final f = new DateFormat('yyyy-MM-dd');

  CardDiscountedPlaces(
      {@required this.items, this.routeName, @required this.onRefresh});

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
                  Navigator.of(context).pushNamed(routeName, arguments: {
                    "companyName": items[i]["companyName"] != null &&
                            items[i]["companyName"].isNotEmpty
                        ? items[i]["companyName"]
                        : "",
                    "companyDiscount": items[i]["companyDiscount"] != null &&
                            items[i]["companyDiscount"].isNotEmpty
                        ? items[i]["companyDiscount"]
                        : "",
                    "companyAdress": items[i]["companyAdress"] != null &&
                            items[i]["companyAdress"].isNotEmpty
                        ? items[i]["companyAdress"]
                        : "",
                    "companyPhone": items[i]["companyPhone"] != null &&
                            items[i]["companyPhone"].isNotEmpty
                        ? items[i]["companyPhone"]
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
                        leading: null,
                        title: Row(
                          children: [
                            Text(
                              'Firma Adı :     ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(items[i]['companyName'],
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Text('İndirim :             ',
                                style: TextStyle(color: Colors.grey)),
                            Text(
                                items[i]['companyDiscount'] != null
                                    ? '%' + items[i]['companyDiscount']
                                    : '',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
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

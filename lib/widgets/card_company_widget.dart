import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardCompanyWidget extends StatelessWidget {
  final bool isFirebase;
  final List items;
  final String routeName;
  final dynamic onRefresh;
  final f = new DateFormat('yyyy-MM-dd');

  CardCompanyWidget(
      {@required this.isFirebase,
      @required this.items,
      this.routeName,
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
              height: 50,
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes
                    : null,
              ),
            );
          },
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        );
      } else {
        return Image.asset(
          './assets/images/logo.jpg',
          height: 50,
          width: 50,
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
              height: 50,
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes
                    : null,
              ),
            );
          },
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        );
      } else {
        return Image.asset(
          './assets/images/logo.jpg',
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        );
      }
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
                          child: firebaseCheck(i),
                        ),
                        title: Text(items[i]['title']),
                        subtitle: Text(items[i]['companyName']),
                        trailing: Text(
                          f.format(DateTime.parse(items[i]['createdAt'])),
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

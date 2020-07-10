import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final dynamic onRefresh;
  final List items;
  final String routeName;
  final bool isFirebase;
  final bool isNews;

  CardWidget(
      {@required this.onRefresh,
      @required this.items,
      this.routeName,
      @required this.isFirebase,
      @required this.isNews});

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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Container(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int i) {
            return InkWell(
              onTap: () {
                if (isNews) {
                  Navigator.of(context).pushNamed(routeName, arguments: {
                    "_id": items[i]["_id"],
                    "title": items[i]["title"],
                    "content": items[i]["content"]
                  });
                } else {
                  Navigator.of(context).pushNamed(routeName, arguments: {
                    "_id": items[i]["_id"],
                    "title": items[i]["title"],
                    "content": items[i]["content"]
                  });
                }
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
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              items[i]['title'], //.substring(0, 95) + '...',
                              style: TextStyle(fontSize: 15),
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

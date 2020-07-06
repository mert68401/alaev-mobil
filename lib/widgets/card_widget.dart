import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final dynamic onRefresh;
  final List items;
  final String routeName;
  final bool isFirebase;

  CardWidget({
    @required this.onRefresh,
    @required this.items,
    this.routeName,
    @required this.isFirebase,
  });

  Widget firebaseCheck(i) {
    if (!isFirebase) {
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
                Navigator.of(context).pushNamed(routeName);
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
                        Positioned(
                          bottom: 20,
                          right: 10,
                          child: Container(
                            width: 300,
                            color: Colors.black54,
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 20,
                            ),
                            child: Text(
                              items[i]['title'],
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              items[i]['content'], //.substring(0, 95) + '...',
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

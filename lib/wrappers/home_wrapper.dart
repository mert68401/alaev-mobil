import 'package:flutter/material.dart';

class HomeWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            elevation: 10,
            leading: Icon(Icons.menu),
            floating: true,
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: AspectRatio(
                aspectRatio: 11 / 2,
                child: Image.asset(
                  "assets/images/slide04.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              centerTitle: true,
              title: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(fontSize: 30),
                          children: <TextSpan>[
                            TextSpan(
                                text: "ALA",
                                style: TextStyle(
                                    color: Theme.of(context).accentColor)),
                            TextSpan(text: "EV")
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: Container(
              color: Theme.of(context).accentColor,
            ),
          )
        ],
      ),
    );
  }
}

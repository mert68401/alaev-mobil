import 'dart:ui';

import 'package:alaev/functions/functions.dart';
import 'package:alaev/functions/requests.dart';
import 'package:alaev/screens/posts/post_create_screen.dart';
// import 'package:alaev/screens/company_list_screen.dart';
import 'package:alaev/screens/posts/post_detail_screen.dart';
import 'package:alaev/screens/user_list_screen.dart';
import 'package:alaev/widgets/card_post_widget.dart';
// import 'package:alaev/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../screens/login_screen.dart';
import '../wrappers/home_wrapper.dart';
import '../wrappers/profile_wrapper.dart';
import '../wrappers/job_adv_wrapper.dart';
import '../wrappers/news_wrapper.dart';
import '../wrappers/company_adv_wrapper.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  final bool loggedIn;
  HomeScreen({@required this.loggedIn});
  @override
  HomeScreenState createState() => HomeScreenState();
}

void customLaunch(command) async {
  if (await canLaunch(command)) {
    await launch(command);
  } else {
    print(' could not launch $command');
  }
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;
  List<Map<String, dynamic>> postList = [];

  final List<String> pageTitles = [
    "ALAEV İSTEKLER",
    "DUYURULAR",
    "İŞ İLANLARI",
    "ANLAŞMALI KURUMLAR",
    "PROFİLİM",
    "ÜYELERİMİZ",
    "WEBSİTEMİZ",
  ];

  final List<List<Color>> colors = [
    [
      Colors.yellow,
      Colors.red,
    ],
    [
      Colors.purpleAccent,
      Colors.lightBlueAccent,
    ],
    [
      Colors.blue,
      Colors.green,
    ],
    [
      Colors.purple,
      Colors.red,
    ],
    [
      Colors.deepPurple,
      Colors.blueGrey,
    ],
    [
      Colors.indigo,
      Colors.teal,
    ],
    [
      Colors.yellow,
      Colors.redAccent,
    ]
  ];
  final List<String> icons = [
    './assets/images/phone.png',
    './assets/images/announcement.png',
    './assets/images/job-seeker.png',
    './assets/images/building.png',
    './assets/images/profile.png',
    './assets/images/community.png',
    './assets/images/worldwide.png',
  ];
  PageController _pageController;
  final double _iconSize = 20;
  List<Widget> _pages = [];

  @override
  void initState() {
    if (mounted) {
      super.initState();
      _pageController = PageController(initialPage: 2);
      getToken().then((value) {
        if (value == null) {
          Navigator.of(context).pushNamed(LoginScreen.routeName);
        }
      });
      getAllPosts().then((list) {
        setState(() {
          if (mounted) {
            postList = list;
            print(postList);
          }
        });
      });
    }
  }

  void routePush() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => HomeWrapper()));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loggedIn) {
      _pages = [
        CompanyAdvertisementWrapper(),
        NewsWrapper(),
        homeScreen(context),
        JobAdvertisementWrapper(),
        ProfileWrapper(),
      ];
    } else {
      _pages = [
        CompanyAdvertisementWrapper(),
        NewsWrapper(),
        homeScreen(context),
        JobAdvertisementWrapper(),
      ];
    }
    return Scaffold(
      // drawer: DrawerWidget(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Text(
                'İstekler',
                style: TextStyle(
                    color: _selectedIndex == 0
                        ? Theme.of(context).accentColor
                        : Colors.grey),
              ),
            ),
            icon: Icon(
              Icons.business,
              size: _iconSize,
              color: _selectedIndex == 0
                  ? Theme.of(context).accentColor
                  : Colors.grey,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            title: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Text('Duyurular',
                  style: TextStyle(
                      color: _selectedIndex == 1
                          ? Theme.of(context).accentColor
                          : Colors.grey)),
            ),
            icon: Icon(
              Icons.apps,
              size: _iconSize,
              color: _selectedIndex == 1
                  ? Theme.of(context).accentColor
                  : Colors.grey,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            title: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Text('Anasayfa',
                  style: TextStyle(
                      color: _selectedIndex == 2
                          ? Theme.of(context).accentColor
                          : Colors.grey)),
            ),
            icon: Icon(
              Icons.home,
              size: _iconSize,
              color: _selectedIndex == 2
                  ? Theme.of(context).accentColor
                  : Colors.grey,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            title: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Text('İş İlanları',
                  style: TextStyle(
                      color: _selectedIndex == 3
                          ? Theme.of(context).accentColor
                          : Colors.grey)),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.sort,
              size: _iconSize,
              color: _selectedIndex == 3
                  ? Theme.of(context).accentColor
                  : Colors.grey,
            ),
          ),
          BottomNavigationBarItem(
            title: widget.loggedIn
                ? MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Text('Profilim',
                        style: TextStyle(
                            color: _selectedIndex == 4
                                ? Theme.of(context).accentColor
                                : Colors.grey)),
                  )
                : MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Text("Giriş Yap",
                        style: TextStyle(
                            color: _selectedIndex == 4
                                ? Theme.of(context).accentColor
                                : Colors.grey)),
                  ),
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.person,
              size: _iconSize,
              color: _selectedIndex == 4
                  ? Theme.of(context).accentColor
                  : Colors.grey,
            ),
          ),
        ],
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            if (index == 4 && !widget.loggedIn) {
              return;
            }
            setState(() => _selectedIndex = index);
          },
          children: _pages,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 4 && !widget.loggedIn) {
      Navigator.of(context).pushNamed(LoginScreen.routeName);
      return;
    } else if (index == 5) {
      Navigator.of(context).pushNamed(UserListScreen.routeName);
      return;
    } else if (index == 6) {
      customLaunch('http://alaev.org.tr');
      return;
    }
    setState(() {
      _selectedIndex = index;
      //
      //
      //using this page controller you can make beautiful animation effects
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            buttonPadding: EdgeInsets.all(15),
            title: new Text('Emin misin?'),
            content: new Text('Uygulamayı kapatmak istiyor musun'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("HAYIR"),
              ),
              SizedBox(width: 16),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("EVET"),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget homeScreen(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {},
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).accentColor,
              onPressed: () {
                Navigator.pushNamed(context, CreatePostScreen.routeName);
              },
              child: Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Theme.of(context).primaryColor, //change your color here
              ),
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    "./assets/images/alaevLogoClean.png",
                    scale: 11,
                  ),
                ],
              ),
            ),
            //grid
            body: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: postList.length,
                itemBuilder: (BuildContext context, int index) {
                  return PostCardWidget(postList[index]);
                })),
      ),
    );
  }
}

// GridView.builder(
//               physics: BouncingScrollPhysics(),
//               itemCount: pageTitles.length,
//               gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
//                   childAspectRatio: 1.15, crossAxisCount: 2),
//               itemBuilder: (BuildContext context, int index) {
//                 return GestureDetector(
//                   onTap: () {
//                     if (index == 2) {
//                       index = 3;
//                     } else if (index == 3) {
//                       index = 2;
//                       Navigator.of(context)
//                           .pushNamed(CompanyListScreen.routeName);
//                     }
//                     _onItemTapped(index);
//                   },
//                   child: Stack(children: [
//                     Container(
//                       margin: EdgeInsets.all(28),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: LinearGradient(colors: colors[index]),
//                         image: DecorationImage(
//                           alignment: Alignment.center,
//                           scale: 10 / 1.4,
//                           image: ExactAssetImage(icons[index]),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(bottom: 5),
//                       child: Text(
//                         pageTitles[index],
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       alignment: Alignment.bottomCenter,
//                     )
//                   ]),
//                 );
//               }),

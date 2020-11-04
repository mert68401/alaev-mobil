import 'dart:ui';

import 'package:alaev/functions/functions.dart';
// import 'package:alaev/screens/company_list_screen.dart';
import 'package:alaev/screens/posts/post_detail_screen.dart';
import 'package:alaev/screens/user_list_screen.dart';
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
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(5),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Eren Doğruca',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        ClipRRect(
                          child: Image.asset("./assets/images/1.jpg"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        print('adsasd');
                                      },
                                      child: FaIcon(FontAwesomeIcons.heart)),
                                  SizedBox(width: 30),
                                  InkWell(
                                      onTap: () {
                                        print('adsasd');
                                      },
                                      child: FaIcon(FontAwesomeIcons.comment))
                                ],
                              ),
                              SizedBox(height: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '20 beğenme',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          'Eren Doğruca' + ' ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Flexible(
                                        flex: 2,
                                        child: Text(
                                          'TestBaş lıkasdddddddddd ddadsdsadsaaasdsaddsadsadsdsadsadsadsadsadsadsadsadsdsdssadsds',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          PostDetailScreen.routeName);
                                    },
                                    child: Text(
                                      'Diğer yorumlar',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ),
                                  Text(
                                    DateFormat('kk:mm').format(DateTime.now()),
                                    textAlign: TextAlign.end,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
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

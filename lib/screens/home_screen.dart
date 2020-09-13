import 'dart:async';

import 'package:alaev/functions/functions.dart';
import 'package:alaev/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';

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
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;
  PageController _pageController;
  final double _iconSize = 20;
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 2);
    getToken().then((value) {
      if (value == null) {
        Navigator.of(context).pushNamed(LoginScreen.routeName);
      }
    });
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
        HomeWrapper(),
        JobAdvertisementWrapper(),
        ProfileWrapper(),
      ];
    } else {
      _pages = [
        CompanyAdvertisementWrapper(),
        NewsWrapper(),
        HomeWrapper(),
        JobAdvertisementWrapper(),
      ];
    }
    return Scaffold(
      drawer: DrawerWidget(),
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
                'İhaleler',
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
    );
  }

  void _onItemTapped(int index) {
    if (index == 4 && !widget.loggedIn) {
      Navigator.of(context).pushNamed(LoginScreen.routeName);
      return;
    }
    setState(() {
      _selectedIndex = index;
      //
      //
      //using this page controller you can make beautiful animation effects
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 250), curve: Curves.easeOut);
    });
  }
}

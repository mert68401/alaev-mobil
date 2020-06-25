import 'package:alaev/wrappers/adv_wrapper.dart';
import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../wrappers/home_wrapper.dart';
import '../wrappers/profile_wrapper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;
  bool _loggedIn;
  PageController _pageController;
  final double _iconSize = 30;
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    //TODO: There will be a logged in checker to set this bool value. Which will be a Future method requests to server.
    _loggedIn = false;
    if (_loggedIn) {
      _pages = [
        AdvertisementWrapper(),
        AdvertisementWrapper(),
        HomeWrapper(),
        AdvertisementWrapper(), // GEÇİCİ
        ProfileWrapper(),
      ];
    } else {
      _pages = [
        AdvertisementWrapper(),
        AdvertisementWrapper(),
        HomeWrapper(),
        AdvertisementWrapper(), // GEÇİCİ
      ];
    }
    _pageController = PageController(initialPage: 2);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            if (index == 4 && !_loggedIn) {
              return;
            }
            setState(() => _selectedIndex = index);
          },
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).accentColor,
        onTap: _onItemTapped,
        backgroundColor: Theme.of(context).primaryColor,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text('Item One'),
            icon: Icon(
              Icons.home,
              size: _iconSize,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            title: Text('Item One'),
            icon: Icon(
              Icons.apps,
              size: _iconSize,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            title: Text('Anasayfa'),
            icon: Icon(
              Icons.home,
              size: _iconSize,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            title: Text('İlanlar'),
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.sort,
              size: _iconSize,
            ),
          ),
          BottomNavigationBarItem(
            title: _loggedIn ? Text('Profilim') : Text("Giriş Yap"),
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.person,
              size: _iconSize,
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 4 && !_loggedIn) {
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

import 'package:account_book/screens/Collector_Profile.dart';
import 'package:account_book/screens/morescreeen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../Constant/Colors/Colors.dart';
import '../../../../Constant/Strings/Strings.dart';
import '../HomeScreen.dart';
import '../custom_icons_icons.dart';
import '../screens/Collector_Screen.dart';
import '../screens/Collector_personal_Profile.dart';
import '../screens/homescreen.dart';
import '../screens/moneyscreen.dart';

class Collector_Bottom_Bar extends StatefulWidget {
  Collector_Bottom_Bar({Key? key, required this.index}) : super(key: key);
  final int index;
  @override
  _BottomBar createState() => _BottomBar();
}

class _BottomBar extends State<Collector_Bottom_Bar> {
  int index = 0;

  bool table = false;

  @override
  void initState() {
    setState(() {
      this.index = widget.index;
    });
    super.initState();
  }

  Widget _bottomnavigationbar() {
    int _currentPage = 0;
    final _pageController = PageController();

    return Container(
      child: BottomNavigationBar(
        elevation: 20,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: MyColors.primarycolor,
        unselectedItemColor: MyColors.grey_color,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: index,
        onTap: (value) {
          print("vlaue=" + value.toString());
          setState(() {
            this.index = value;
            switch (index) {
              case 0:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreen()));
                break;

              case 1:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Collector_personal_Profile()));
                break;
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: MyColors.primarycolor,
            icon: Icon(
              CupertinoIcons.home,
              size: 30,
            ),
            label: ConstStr.home,
          ),
          BottomNavigationBarItem(
              backgroundColor: MyColors.primarycolor,
              icon: Icon(Icons.person, size: 30),
              label: ConstStr.profile),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _bottomnavigationbar();
  }
}

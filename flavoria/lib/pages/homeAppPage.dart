import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flavoria/AppColors.dart';
import 'package:flavoria/pages/navPages/Favorites.dart';
import 'package:flavoria/pages/navPages/Home.dart';
import 'package:flavoria/pages/navPages/Plan.dart';
import 'package:flavoria/pages/navPages/Search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  int currentIndex = 0;
  List<Widget> widgetOptions = <Widget>[
    Home(),
    Search(),
    Favorites(),
    Plan(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: widgetOptions.elementAt(currentIndex),
        bottomNavigationBar: ConvexAppBar(
          items: const [
            TabItem(
                icon: Icon(
                  Icons.home_outlined,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                title: 'Home',
                activeIcon: Icon(Icons.home, color: AppColors.basicColor)),
            TabItem(
              icon: Icon(
                Icons.search,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              title: 'Search',
              activeIcon:
                  Icon(Icons.search_outlined, color: AppColors.basicColor),
            ),
            TabItem(
                icon: Icon(
                  Icons.favorite_border,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                title: 'Favorites',
                activeIcon: Icon(Icons.favorite, color: AppColors.basicColor)),
            TabItem(
                icon: Icon(
                  Icons.calendar_month_outlined,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                title: 'MyPlan',
                activeIcon:
                    Icon(Icons.calendar_month, color: AppColors.basicColor)),
          ],
          initialActiveIndex: currentIndex,
          onTap: changeItem,
          backgroundColor: AppColors.basicColor,
        ));
  }

  void changeItem(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}

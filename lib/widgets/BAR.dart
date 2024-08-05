import 'package:estore2/Views/Profile.dart';
import 'package:estore2/Views/cartScreen.dart';
import 'package:estore2/Views/home.dart';
import 'package:flutter/material.dart';

class BottomW extends StatefulWidget {
  @override
  State<BottomW> createState() => _BottomWState();
}

class _BottomWState extends State<BottomW> {
  int current = 0;
  final List tabs = [
    HOME(),
    CartScreen(),
    Profile(),
    // {'page': HOME(), "title": "HOME"},
    // {'page': CartScreen(), "title": "Cart"},
    // {'page': Profile(), "title": "Profile"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: darkController.getDarkTheme
      //       ? Theme.of(context).cardColor
      //       : Colors.white,
      //   title: Text(
      //     tabs[current]['title'],
      //     style: TextStyle(
      //       color: darkController.getDarkTheme ? Colors.white : Colors.black,
      //     ),
      //   ),
      // ),
      bottomNavigationBar: Material(
        elevation: 20.0, // Set the elevation as needed
        child: BottomNavigationBar(
          backgroundColor: Theme.of(context).cardColor,
          // backgroundColor: darkController.getDarkTheme
          //     ? Theme.of(context).cardColor
          //     : Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: current,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          items: [
            BottomNavigationBarItem(
                label: "",
                icon: Icon(
                  Icons.home,
                  size: 30,
                  color: current == 0 ? Color(0xff53A4Af) : Colors.grey,
                )),
            BottomNavigationBarItem(
                label: "",
                icon: Icon(
                  Icons.shopping_cart,
                  size: 30,
                  color: current == 1 ? Color(0xff53A4Af) : Colors.grey,
                )),
            BottomNavigationBarItem(
                label: "",
                icon: Icon(
                  Icons.person_2,
                  size: 30,
                  color: current == 2 ? Color(0xff53A4Af) : Colors.grey,
                )),
          ],
          onTap: (index) {
            setState(() {
              current = index;
            });
          },
        ),
      ),
      body: tabs[current],
    );
  }
}

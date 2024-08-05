import 'package:estore2/Controller/UserController.dart';
import 'package:estore2/Views/admin/OrderScreen.dart';
import 'package:estore2/Views/admin/ProductScreen.dart';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/get.dart';

class AdminBottomBar extends StatefulWidget {
  const AdminBottomBar({super.key});

  @override
  State<AdminBottomBar> createState() => _AdminBottomBarState();
}

class _AdminBottomBarState extends State<AdminBottomBar> {
  late List<Widget> pages;
  late AddProduct addProduct;
  late OrdersPage orderScreen;
  final UserController userController = Get.put(UserController());
  int currentTabindex = 0;
  @override
  void initState() {
    addProduct = AddProduct();
    orderScreen = OrdersPage(
      user: userController.user.value,
    );
    pages = [addProduct, orderScreen];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Color(0xFF0a0d2c),
        color: Color(0xFF0a0d2c),
        // animationCurve: Curves.ease,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabindex = index;
          });
        },
        items: [
          Icon(
            Icons.add,
            color: Colors.white,
          ),
          Icon(
            Icons.inventory,
            color: Colors.white,
          ),
        ],
      ),
      body: pages[currentTabindex],
    );
  }
}

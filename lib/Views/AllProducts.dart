import 'package:estore2/Controller/ProductController.dart';
import 'package:estore2/Controller/darkThemeController.dart';
import 'package:estore2/widgets/TILE/ProductTile.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllProducts extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();
  final DarkThemeController darkController = Get.find<DarkThemeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          darkController.getDarkTheme ? Color(0xFF0a0d2c) : Color(0xfff2f2f2),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: darkController.getDarkTheme ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor:
            darkController.getDarkTheme ? Color(0xFF0a0d2c) : Color(0xfff2f2f2),
        surfaceTintColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Product Shelf",
          style: TextStyle(
            color: darkController.getDarkTheme ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Obx(() {
        if (productController.products.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else {
          return GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(5),
            itemCount: productController.products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 7.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final product = productController.products[index];
              return SingleChildScrollView(
                child: Container(
                  child: ProductTile(product: product),
                ),
              );
            },
          );
        }
      }),
    );
  }
}

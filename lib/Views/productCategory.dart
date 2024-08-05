import 'package:estore2/Controller/ProductController.dart';
import 'package:estore2/Controller/darkThemeController.dart';
import 'package:estore2/widgets/TILE/ProductTile.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsByCategory extends StatelessWidget {
  final String category;

  ProductsByCategory({required this.category});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find();
    final DarkThemeController darkController = Get.find<DarkThemeController>();
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
        title: Text(
          'Products in $category',
          style: TextStyle(
            color: darkController.getDarkTheme
                ? Color(0xfff2f2f2)
                : Color(0xFF0a0d2c),
          ),
        ),
      ),
      body: Obx(() {
        if (productController.products.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else {
          // return ListView.builder(
          //   itemCount: productController.products.length,
          //   itemBuilder: (context, index) {
          //     final product = productController.products[index];
          //     return ProductTile(product: product);
          //   },
          // );
          return GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(5),
            itemCount: productController.products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 7.0,
              mainAxisSpacing: 7.0,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final product = productController.products[index];
              return Container(
                child: ProductTile(product: product),
              );
            },
          );
        }
      }),
    );
  }
}

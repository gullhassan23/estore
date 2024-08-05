import 'package:estore2/Constants/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../Controller/ProductController.dart';
import '../../Views/productCategory.dart';

class CategoryTile extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  final String image;
  final String dataCat;
  final String cat;
  CategoryTile({
    Key? key,
    this.image = '',
    this.dataCat = '',
    this.cat = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        productController.fetchProductsByCategory(cat);
        Get.to(() => ProductsByCategory(
              category: cat,
            ));
      },
      child: Container(
        width: 100.w,
        margin: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              image,
              height: 50.h,
              width: 50.w,
              fit: BoxFit.cover,
            ),
            Text(
              cat,
              style: texTsTyle.buildTextField(Colors.black, 17),
            ),
            Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
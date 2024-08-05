import 'package:estore2/Constants/images.dart';
import 'package:estore2/Constants/textStyles.dart';
import 'package:estore2/Controller/ProductController.dart';
import 'package:estore2/Controller/UserController.dart';
import 'package:estore2/Controller/darkThemeController.dart';
import 'package:estore2/MODELS/ProductModel.dart';
import 'package:estore2/Views/productDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductTile extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  final UserController userController = Get.put(UserController());
  final ProductModel product;

  ProductTile({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DarkThemeController darkController = Get.find<DarkThemeController>();
    return GestureDetector(
      onTap: () {
        productController.fetchProductData();
        Get.to(() => ProductDetail(
              productModel: product,
              user: userController.user.value,
            ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 20.w),
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        decoration: BoxDecoration(
          color: Color(0xffF5F5DC),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Image.network(
              product.imageUrls.isNotEmpty
                  ? product.imageUrls[0]
                  : Mainimages[3],
              height: 100.h,
              width: 100.w,
              fit: BoxFit.cover,
            ),
            Text(
              product.productName,
              style: texTsTyle.buildTextField(Colors.black, 20.sp),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${product.cost.toString()}",
                  style: TextStyle(
                    color: Color(0xFFfd6f3e),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: darkController.getDarkTheme
                        ? Colors.orange
                        : Colors.brown,
                  ),
                  child: Icon(
                    size: 20.sp,
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            )
          ],
        ),
      ),
    );
  }
}
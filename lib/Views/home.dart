
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:estore2/widgets/TILE/CategoryTile.dart';
import 'package:estore2/widgets/TILE/ProductTile.dart';
import 'package:estore2/Constants/images.dart';
import 'package:estore2/Constants/textStyles.dart';
import 'package:estore2/Controller/ProductController.dart';
import 'package:estore2/Controller/UserController.dart';
import 'package:estore2/Views/AllProducts.dart';
import 'package:estore2/widgets/textForm.dart';

import '../Controller/darkThemeController.dart';

class HOME extends StatefulWidget {
  const HOME({super.key});

  @override
  State<HOME> createState() => _HOMEState();
}

class _HOMEState extends State<HOME> {
  final search = TextEditingController();
  final UserController userController = Get.put(UserController());
  final ProductController productController = Get.put(ProductController());

  List categories = [
    Mainimages[3],
    Mainimages[2],
    Mainimages[6],
    Mainimages[7],
  ];

  List categoryName = ['headphone', 'TV', 'MIC', 'LED'];

  Map<String, dynamic> getGreetingAndImage() {
    final currentTime = DateTime.now();
    final hour = currentTime.hour;

    if (hour < 12) {
      return {'greeting': 'GOOD MORNING', 'icon': CupertinoIcons.sun_haze};
    } else if (hour < 18) {
      return {'greeting': 'GOOD AFTERNOON', 'icon': Icons.wb_sunny};
    } else {
      return {'greeting': 'GOOD NIGHT', 'icon': CupertinoIcons.moon};
    }
  }

  @override
  void initState() {
    super.initState();
    userController.fetchUserData();
  }

  void searchProduct(String value) {
    productController.searchProduct(value.obs);
  }

  @override
  Widget build(BuildContext context) {
    final DarkThemeController darkController = Get.find<DarkThemeController>();
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          extendBody: true,
          backgroundColor: darkController.getDarkTheme
              ? Color(0xFF0a0d2c)
              : Color(0xfff2f2f2),
          body: Container(
            margin: EdgeInsets.only(top: 30.h, left: 20.w, right: 20.w),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            return Text(
                              "Hey, ${userController.user.value.name}",
                              style: texTsTyle.buildTextField(
                                  darkController.getDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  20.sp),
                            );
                          }),
                          SizedBox(height: 10.h),
                          GestureDetector(
                            onTap: () {
                              userController.logout(context);
                            },
                            child: Row(
                              children: [
                                Text(
                                  getGreetingAndImage()['greeting']!,
                                  style: texTsTyle.buildTextField(
                                      darkController.getDarkTheme
                                          ? Colors.white
                                          : Colors.black,
                                      16.sp),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                if (getGreetingAndImage()['icon'] != null)
                                  Icon(
                                    getGreetingAndImage()['icon'],
                                    color: darkController.getDarkTheme
                                        ? Colors.white
                                        : Colors.black,
                                    size: 30.sp,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Obx(() {
                        if (userController.user.value.photoUrl.isEmpty) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Image.asset(
                              Mainimages[0],
                              height: 70.h,
                              width: 70.h,
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Image.network(
                              userController.user.value.photoUrl,
                              height: 70.h,
                              width: 70.h,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  TextForm(
                    onChanged: (value) {
                      searchProduct(value);
                    },
                    icon: Icon(
                      Icons.search,
                      size: 23.sp,
                    ),
                    textEditingController: search,
                    hintText: "Search Product",
                    textInputType: TextInputType.name,
                  ),
                  SizedBox(height: 20.h),
                  GetBuilder<ProductController>(
                    id: 'search',
                    builder: (productController) {
                      if (search.text.isEmpty) {
                        return SizedBox.shrink();
                      } else if (productController.productSearch.isEmpty) {
                        return Center(child: Text('No products found'));
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(16),
                          itemCount: productController.productSearch.length,
                          itemBuilder: (ctx, index) {
                            final product =
                                productController.productSearch[index];
                            return ProductTile(product: product);
                          },
                        );
                      }
                    },
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Categories",
                    style: texTsTyle.buildTextField(
                        darkController.getDarkTheme
                            ? Colors.white
                            : Colors.black,
                        20.sp),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Container(
                        height: 130.h,
                        width: 50.w,
                        margin: EdgeInsets.only(right: 20.w),
                        decoration: BoxDecoration(
                          color: darkController.getDarkTheme
                              ? Colors.orange
                              : Colors.brown,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Center(
                          child: Text(
                            'All',
                            style:
                                texTsTyle.buildTextField(Colors.white, 20.sp),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 130.h,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (ctx, index) {
                              return CategoryTile(
                                image: categories[index],
                                cat: categoryName[index],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "All products",
                        style: texTsTyle.buildTextField(
                            darkController.getDarkTheme
                                ? Colors.white
                                : Colors.black,
                            20.sp),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => AllProducts());
                        },
                        child: Text(
                          "see all",
                          style: texTsTyle.buildTextField(
                              darkController.getDarkTheme
                                  ? Colors.white
                                  : Colors.orange,
                              17.sp),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Obx(() {
                    if (productController.products.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Container(
                        decoration: BoxDecoration(),
                        height: 180.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productController.products.length,
                          itemBuilder: (context, index) {
                            final product = productController.products[index];
                            return ProductTile(product: product);
                          },
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
        ));
  }
}

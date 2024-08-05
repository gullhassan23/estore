

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:estore2/Controller/CartController.dart';
import 'package:estore2/Controller/darkThemeController.dart';
import 'package:estore2/Resources/Functions.dart';
import 'package:estore2/widgets/BAR.dart';
import 'package:estore2/Constants/images.dart';
import 'package:estore2/Constants/textStyles.dart';
import 'package:estore2/MODELS/ProductModel.dart';
import 'package:estore2/MODELS/UserModel.dart';
import 'package:get/get.dart';

class ProductDetail extends StatefulWidget {
  final CartController cartController = Get.put(CartController());
  final ProductModel productModel;
  final Users user;
  ProductDetail({
    Key? key,
    required this.productModel,
    required this.user,
  }) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  CommonFunctions commonFunctions = CommonFunctions();

  @override
  void initState() {
    super.initState();
    // ontheload();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _rotateImage() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final DarkThemeController darkController = Get.find<DarkThemeController>();
    return Scaffold(
      backgroundColor:
          darkController.getDarkTheme ? Color(0xFF0a0d2c) : Color(0xfff2f2f2),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: 50.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Icon(
                        
                        Icons.arrow_back_ios_new_outlined,
                        color: darkController.getDarkTheme
                            ? Colors.white
                            : Colors.brown,
                        size: 29.sp,
                      ),
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: _rotateImage,
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform(
                            transform:
                                Matrix4.rotationY(_animation.value * 3.14),
                            alignment: Alignment.center,
                            child: Image.network(
                              widget.productModel.imageUrls.isNotEmpty
                                  ? widget.productModel.imageUrls[0]
                                  : Mainimages[8],
                              height: 300.h,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: ScreenUtil().screenWidth,
                padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
                decoration: BoxDecoration(
                  color: darkController.getDarkTheme
                      ? Color(0xFF0a0d2c)
                      : Color(0xfff2f2f2),
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(20.r)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.productModel.productName,
                          style: texTsTyle.buildTextField(
                              darkController.getDarkTheme
                                  ? Colors.orange
                                  : Colors.black,
                              23.sp),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "\$${widget.productModel.cost.toString()}",
                          style: texTsTyle.buildTextField(
                              darkController.getDarkTheme
                                  ? Colors.orange
                                  : Colors.black,
                              17.sp),
                        ),
                      ],
                    ),
                    Text(
                      'Description',
                      style: texTsTyle.buildTextsmallField(
                          darkController.getDarkTheme
                              ? Colors.orange
                              : Colors.black,
                          18.sp),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      widget.productModel.description.toString(),
                      style: TextStyle(
                        color: darkController.getDarkTheme
                            ? Colors.orange
                            : Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 80.h,
                    ),
                    // GestureDetector(
                    //   onTap: () async {
                    //     await widget.cartController
                    //         .addToCart(widget.productModel);
                    //     if (widget.cartController.addTocartStatus.value ==
                    //         "success") {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         SnackBar(
                    //             content:
                    //                 Text("Product added to cart successfully")),
                    //       );
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => CartScreen()));
                    //     } else {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         SnackBar(
                    //             content: Text(widget
                    //                 .cartController.addTocartStatus.value)),
                    //       );
                    //     }
                    //   },
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(vertical: 10.w),
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10.r),
                    //       color: Color(0xfffd6f3e),
                    //     ),
                    //     width: ScreenUtil().screenWidth,
                    //     child: Center(
                    //       child: Text(
                    //         "Buy Now",
                    //         style:
                    //             texTsTyle.buildTextField(Colors.white, 18.sp),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () async {
                        // List<Uint8List> images =
                        //     await _fetchImages(widget.productModel.imageUrls);
                        await widget.cartController
                            .addToCart(widget.productModel);
                        if (widget.cartController.addTocartStatus.value ==
                            "success") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text("Product added to cart successfully"),
                            ),
                          );
                          Get.to(() => BottomW());
                          // Navigate to CartScreen after adding to cart
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  widget.cartController.addTocartStatus.value),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: darkController.getDarkTheme
                              ? Colors.orange
                              : Colors.brown,
                        ),
                        width: ScreenUtil().screenWidth,
                        child: Center(
                          child: Text(
                            "Buy Now",
                            style: texTsTyle.buildTextField(
                                Color(0xfff2f2f2), 18.sp),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

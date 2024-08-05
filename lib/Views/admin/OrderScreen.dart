import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estore2/Controller/OrderController.dart';
import 'package:estore2/Controller/ProductController.dart';
import 'package:estore2/Controller/UserController.dart';
import 'package:estore2/MODELS/UserModel.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../Controller/darkThemeController.dart';

class OrdersPage extends StatefulWidget {
  final Users user;

  const OrdersPage({super.key, required this.user});
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrderController orderController = Get.put(OrderController());
  final ProductController productController = Get.put(ProductController());
  final UserController userController = Get.put(UserController());
  final DarkThemeController darkController = Get.put(DarkThemeController());
  @override
  void initState() {
    super.initState();
    orderController.checkAdminStatus().then((_) {
      if (orderController.isAdmin.value) {
        orderController.adminfetchOrdersData();
      }
    });
    orderController.checkAdminStatus();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), minTextAdapt: true);

    return Scaffold(
      backgroundColor:
          darkController.getDarkTheme ? Color(0xFF0a0d2c) : Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor:
            darkController.getDarkTheme ? Color(0xFF0a0d2c) : Color(0xfff2f2f2),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Orders',
          style: TextStyle(
              color: darkController.getDarkTheme
                  ? Color(0xfff2f2f2)
                  : Colors.black,
              fontSize: 20.sp),
        ),
      ),
      body: Obx(() {
        if (orderController.orders.isEmpty) {
          return Center(
              child: Text('No orders found',
                  style: TextStyle(
                      color: darkController.getDarkTheme
                          ? Color(0xfff2f2f2)
                          : Colors.black,
                      fontSize: 16.sp)));
        } else {
          return ListView.builder(
            itemCount: orderController.orders.length,
            itemBuilder: (context, index) {
              final order = orderController.orders[index];
              return Card(
                color:
                    darkController.getDarkTheme ? Colors.orange : Colors.brown,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 10.h, right: 13.w, left: 13.w, bottom: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Image.network(
                            order.productImage,
                            width: 50.w,
                            height: 50.h,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order.productName,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.sp)),
                          Text(
                            'Quantity: ${order.quantity}\nPrice: \$${order.price}',
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.userName,
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                          Row(
                            children: [
                              if (order.status != 'On the way')
                                GestureDetector(
                                  onTap: () async {
                                    await FirebaseFirestore.instance
                                        .collection('orders')
                                        .doc(order.userid)
                                        .collection("productx")
                                        .doc(order.pid)
                                        .update({'status': 'On the way'});
                                    print(
                                        "product dispatched  ${order.productName}");
                                    orderController.adminfetchOrdersData();
                                  },
                                  child: Card(
                                    color: darkController.getDarkTheme
                                        ? Color(0xffFFFDD0)
                                        : Color(0xffBAB86C),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0.w),
                                        child: Text("Ready to dispatch",
                                            style: TextStyle(fontSize: 14.sp)),
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Text(
                                  "Product is dispatched",
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 10.sp),
                                ),
                              IconButton(
                                onPressed: () async {
                                  await orderController.deleteOrder(
                                      order.userid, order.pid);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  size: 24.w,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}

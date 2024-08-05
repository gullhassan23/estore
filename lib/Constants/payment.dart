import 'dart:convert';
import 'package:estore2/Controller/OrderController.dart';
import 'package:estore2/Controller/CartController.dart';

import 'package:estore2/Controller/UserController.dart';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PaymentMethod {
  final CartController cartController = Get.find();
  final OrderController orderController = Get.find();
  final UserController userController = Get.put(UserController());
  Map<String, dynamic>? paymentIntent;
  // final Cart cart;

  // PaymentMethod(this.cart);
  Future<void> makePayment2() async {
    try {
      paymentIntent = await createPaymentIntent();
      var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "US", currencyCode: "USD", testEnv: true);
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!["client_secret"],
        style: ThemeMode.light,
        merchantDisplayName: "HASSAN",
        googlePay: gpay,
      ));
      await displayPaymentSheet(); // Ensure payment sheet is displayed after initialization
    } catch (e) {
      print("Error initializing payment sheet: ${e.toString()}");
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      // await saveOrderToFirestore();
      await orderController.ordertoFirestore();

      print('Order sent to Firestore');
      // await cartController.clearCart();
      // Map<String, dynamic> orderInfo = {
      //   'productID':widget.productModel.uid,
      //   'productCategory':widget.productModel.type,
      //   'ProductName': widget.productModel.productName,
      //   'cost': widget.productModel.cost,
      //   "Name": widget.user.name,
      //   "Email": widget.user.email,
      //   "imageUrls": widget.productModel.imageUrls
      // };
      // await cloud().order(orderInfo);
      print('Payment done');
    } catch (e) {
      print("Failed to display payment sheet: ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent() async {
    try {
      Map<String, dynamic> body = {
        "amount": "100", // Consider adjusting the amount as needed
        "currency": "USD",
      };

      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization":
                "Bearer sk_test_51LYvOaG5oJVKdCdoSBgJVQY3FtPewAydxJ7k5uWmr2wUu4l9pRlDExp6SjqSpT2Lcdw26a60CEhzwlPANWymF9E700qG7AlO7L",
            "Content-Type": "application/x-www-form-urlencoded"
          });
      return json.decode(response.body);
    } catch (e) {
      throw Exception("Failed to create payment intent: ${e.toString()}");
    }
  }

  // Future<void> saveOrderToFirestore() async {
  //   User currentUser = FirebaseAuth.instance.currentUser!;
  //   // Implement your Firestore logic here to save order data
  //   // Example:
  //   await FirebaseFirestore.instance.collection('orders').add({
  //     'userId': currentUser.uid,
  //     'totalAmount': cartController.totalPrice.value,
  //     'items': cartController.cartItems.map((item) => item.data()).toList(),
  //     'timestamp': Timestamp.now(),
  //     'userName': userController.user.value.name
  //   });
  // }
}

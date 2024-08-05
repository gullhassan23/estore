import 'package:cached_network_image/cached_network_image.dart';
import 'package:estore2/Constants/payment.dart';
import 'package:estore2/Constants/textStyles.dart';
import 'package:estore2/Controller/CartController.dart';
import 'package:estore2/Controller/OrderController.dart';
import 'package:estore2/Controller/darkThemeController.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());
  final OrderController orderController = Get.put(OrderController());
  @override
  Widget build(BuildContext context) {
    final DarkThemeController darkController = Get.find<DarkThemeController>();
    return Scaffold(
      backgroundColor:
          darkController.getDarkTheme ? Color(0xFF0a0d2c) : Color(0xfff2f2f2),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            darkController.getDarkTheme ? Color(0xFF0a0d2c) : Color(0xfff2f2f2),
        centerTitle: true,
        title: Text(
          "Your Selections",
          style: texTsTyle.buildTextField(
              darkController.getDarkTheme ? Colors.white : Colors.black, 26),
        ),
        elevation: 0.0,
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Text(
              'Your cart is empty.',
              style: TextStyle(
                  color:
                      darkController.getDarkTheme ? Colors.white : Colors.black,
                  fontSize: 13.0),
            ),
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartController.cartItems[index];
                    final cartItemId = cartItem.id;
                    final itemData = cartItem.data() as Map<String, dynamic>;
                    final int quantity = (itemData['quantity'] is int)
                        ? itemData['quantity']
                        : int.tryParse(itemData['quantity'].toString()) ?? 0;

                    final double price = (itemData['cost'] is double)
                        ? itemData['cost']
                        : double.tryParse(itemData['cost'].toString()) ?? 0.0;

                    final double totalPriceForItem = price * quantity;

                    return Card(
                      color: darkController.getDarkTheme
                          ? Colors.orange
                          : Colors.brown,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error,
                                      color: darkController.getDarkTheme
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    imageUrl: itemData['imageUrls'] != null &&
                                            itemData['imageUrls'].isNotEmpty
                                        ? itemData['imageUrls'][0]
                                        : 'default_image_url', // Provide a default image URL if necessary
                                    height: 100.0,
                                    width: 100.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      itemData['productName'] ?? '',
                                      style: GoogleFonts.fredoka(
                                        color: darkController.getDarkTheme
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (quantity > 1) {
                                              cartController.updateQuantity(
                                                  cartItemId, quantity - 1);
                                            } else {
                                              Get.snackbar("Quantity Message",
                                                  "Quantity canot be zero");
                                            }
                                          },
                                          child: Icon(
                                            Icons.remove,
                                            color: darkController.getDarkTheme
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Text(
                                          quantity.toString(),
                                          style: GoogleFonts.fredoka(
                                            color: darkController.getDarkTheme
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        InkWell(
                                          onTap: () {
                                            cartController.updateQuantity(
                                                cartItemId, quantity + 1);
                                          },
                                          child: Icon(
                                            Icons.add,
                                            color: darkController.getDarkTheme
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$ ${totalPriceForItem.toStringAsFixed(2)}',
                                  style: GoogleFonts.fredoka(
                                    color: darkController.getDarkTheme
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                InkWell(
                                  onTap: () {
                                    cartController.removeFromCart(cartItemId);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: darkController.getDarkTheme
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(() => Text(
                          'Total Amount: \$ ${cartController.totalPrice.value.toStringAsFixed(2)}',
                          style: GoogleFonts.fredoka(
                            color: darkController.getDarkTheme
                                ? Colors.white
                                : Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkController.getDarkTheme
                      ? Colors.orange
                      : Colors.brown,
                ),
                onPressed: () async {
                  if (cartController.totalPrice > 0) {
                    await PaymentMethod().makePayment2();
                    cartController.clearCart(); // Clear the cart after payment
                  } else {
                    Get.snackbar("Payment Message", "Cart is empty");
                  }
                },
                child: Text(
                  'Buy Now',
                  style: TextStyle(
                    color: darkController.getDarkTheme
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estore2/MODELS/ProductModel.dart';
import 'package:estore2/Resources/Functions.dart';
import 'package:estore2/Resources/cloud.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  CommonFunctions commonFunctions = CommonFunctions();
  RxList<ProductModel> products = <ProductModel>[].obs;
  RxList<ProductModel> productSearch = <ProductModel>[].obs;
  RxString addToDBStatus = ''.obs;
  RxString query = ''.obs;
  RxString id = ''.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProductData();
      findById(id);
      searchProduct(query); // Ensure this is an RxString
    });
  }

  ProductModel findById(id) {
    return products.firstWhere((product) => product.uid == id,
        orElse: () => ProductModel(createdAT: DateTime.now()));
  }

  Future<void> fetchProductData() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('products').get();
      if (snapshot.docs.isNotEmpty) {
        products.clear();
        for (var doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          ProductModel product = ProductModel.fromMap(data);
          products.add(product);
        }
        print("Products fetched successfully: ${products.length}");
      } else {
        print("No products found in the database.");
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print("Error fetching product data: $e");
    }
  }

  void fetchProductsByCategory(String category) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('type', isEqualTo: category)
          .get();

      products.value = querySnapshot.docs.map((doc) {
        return ProductModel(
          createdAT: DateTime.now(),
          uid: doc.id,
          productName: doc['productName'],
          type: doc['type'],
          cost: doc['cost'].toDouble(),
          imageUrls: List<String>.from(doc['imageUrls']),
        );
      }).toList();
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<String> productToFirestore({
    String type = '',
    String quantity = '',
    required String productName,
    required String rawCost,
    required String description,
    required List<Uint8List> images,
  }) async {
    try {
      // Parse quantity and check for errors

      try {} catch (e) {
        addToDBStatus.value = "Invalid quantity: must be an integer.";
        return "Invalid quantity: must be an integer.";
      }

      // Upload product to the database
      String status = await cloud().uploadProductToDatabase(
        quantity: quantity,
        productName: productName,
        description: description,
       rawCost: rawCost,
        type: type,
        images: images,
      );

      // Update status based on the result
      if (status == "success") {
        addToDBStatus.value = "Product added to cart successfully";
        fetchProductData(); // Refresh the cart items after adding
      } else {
        addToDBStatus.value = status;
      }
      return status;
    } catch (e) {
      // Log and return the error
      addToDBStatus.value = "Error: ${e.toString()}";
      return "Error: ${e.toString()}";
    }
  }

  Future<void> searchProduct(RxString query) async {
    if (query.value.isEmpty) {
      productSearch.clear();
    } else {
      productSearch.value = products
          .where((product) => product.productName
              .toLowerCase()
              .contains(query.value.toLowerCase()))
          .toList();
    }
    update(['search']);
  }
}

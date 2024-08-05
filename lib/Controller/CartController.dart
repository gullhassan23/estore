import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estore2/MODELS/CartModel.dart';
import 'package:estore2/MODELS/ProductModel.dart';
import 'package:estore2/Resources/Functions.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItems = <QueryDocumentSnapshot>[].obs;
  var totalPrice = 0.0.obs;
  RxString addTocartStatus = ''.obs;
  CommonFunctions cMethod = CommonFunctions();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  Future<void> clearCart() async {
    try {
      User currentUser = firebaseAuth.currentUser!;
      DocumentReference cartDocRef = FirebaseFirestore.instance
          .collection("addTocart")
          .doc(currentUser.uid);

      // Check if the document exists before attempting to delete it
      DocumentSnapshot cartDocSnapshot = await cartDocRef.get();
      if (cartDocSnapshot.exists) {
        // Delete the document (cart)
        await cartDocRef.delete();
        print('Cart document deleted from Firestore.');
      } else {
        print('Cart document does not exist.');
      }

      // Clear local cart items and total price
      cartItems.clear();
      totalPrice.value = 0.0;
    } catch (e) {
      print("Failed to clear cart: ${e.toString()}");
    }
  }

  // Mock method to get product quantity from Firestore
  Future<int> getProductQuantity(String productId) async {
    // Fetch product from Firestore using productId and get the available quantity
    DocumentSnapshot productDoc = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();
    if (productDoc.exists) {
      return productDoc['quantity'];
    } else {
      return 0;
    }
  }

  Future<void> fetchCartItems() async {
    User currentUser = firebaseAuth.currentUser!;
    final snapshot = await firebaseFirestore
        .collection('addTocart')
        .doc(currentUser.uid)
        .collection("products")
        .get();
    cartItems.value = snapshot.docs;
    calculateTotalPrice();
  }

  void calculateTotalPrice() {
    double total = 0.0;
    for (var cartItem in cartItems) {
      final itemData = cartItem.data() as Map<String, dynamic>;
      // final price = itemData['price'] ?? 0.0;
      // final quantity = itemData['quantity'] ?? 1;
      final double price = double.tryParse(itemData['cost'].toString()) ?? 0.0;
      final int quantity = int.tryParse(itemData['quantity'].toString()) ?? 0;
      total += price * quantity;
    }
    totalPrice.value = total;
  }

  void removeFromCart(String cartItemId) {
    User currentUser = firebaseAuth.currentUser!;
    firebaseFirestore
        .collection('addTocart')
        .doc(currentUser.uid)
        .collection("products")
        .doc(cartItemId)
        .delete();
    fetchCartItems(); // Refresh the cart items after removing
  }

  void updateQuantity(String cartItemId, int quantity) {
    User currentUser = firebaseAuth.currentUser!;
    if (quantity > 0) {
      firebaseFirestore
          .collection('addTocart')
          .doc(currentUser.uid)
          .collection("products")
          .doc(cartItemId)
          .update({'quantity': quantity});
      fetchCartItems(); // Refresh the cart items after updating
    } else {
      Get.snackbar("Quantity Message", "Quantity cannot be zero");
    }
  }

  Future<Map<String, dynamic>> getProductData(String productId) async {
    DocumentSnapshot productSnapshot =
        await firebaseFirestore.collection('products').doc(productId).get();

    return productSnapshot.exists
        ? productSnapshot.data() as Map<String, dynamic>
        : {};
  }

  Future<void> deleteCart(String cartItemId) async {
    User currentUser = firebaseAuth.currentUser!;
    firebaseFirestore
        .collection('addTocart')
        .doc(currentUser.uid)
        .collection("products")
        .doc(cartItemId) // Make sure cartItemId is not null or empty
        .delete();
  }

  Future<void> addToCart(ProductModel productModel) async {
    try {
      cartItems.clear();
      String uid = cMethod.getUid();
      User currentUser = firebaseAuth.currentUser!;
      CollectionReference cartCollection = firebaseFirestore
          .collection('addTocart')
          .doc(currentUser.uid)
          .collection("products");

      DocumentReference productDoc = cartCollection.doc(productModel.uid);

      DocumentSnapshot productSnapshot = await productDoc.get();

      if (productSnapshot.exists) {
        // If the product is already in the cart, update the quantity
        int currentQuantity = productSnapshot.get('quantity');
        productDoc.update({'quantity': currentQuantity + 1});
      } else {
        // If the product is not in the cart, add it using Cart model
        Cart cart = Cart(
          cid: uid,
          productImage: productModel.imageUrls.isNotEmpty
              ? productModel.imageUrls[0]
              : '',
          productName: productModel.productName,
          cost: productModel.cost,
          productId: productModel.uid,
          quantity: 1,
          orderedAt: DateTime.now(),
          uSerid: currentUser.uid,
        );

        await cartCollection.doc(productModel.uid).set(cart.toMap());
      }

      addTocartStatus.value = "success";
      fetchCartItems(); // Refresh the cart items after adding
    } catch (e) {
      addTocartStatus.value = e.toString();
    }
  }
}

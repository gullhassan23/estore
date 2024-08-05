import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estore2/MODELS/PicModel.dart';
import 'package:estore2/MODELS/ProductModel.dart';
import 'package:estore2/Resources/Functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class cloud {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User currentUser = FirebaseAuth.instance.currentUser!;
  CommonFunctions cMethod = CommonFunctions();
  Future<String> uploadProfileToStorage(
      Uint8List file, bool isPost, String uid) async {
    Reference storageRef =
        FirebaseStorage.instance.ref().child("users").child(uid);
    UploadTask uploadToask = storageRef.putData(file);
    TaskSnapshot task = await uploadToask;

    return task.ref.getDownloadURL();
  }

  Future<String> AddToCart({
    required String title,
    required String desc,
    required double cost,
    required String type,
    required List<Uint8List?> images,
  }) async {
    User currentUser = firebaseAuth.currentUser!;
    String output = "Something went wrong";

    if (title.isNotEmpty && desc.isNotEmpty && cost > 0) {
      try {
        String uid = cMethod.getUid();
        List<String> imageUrls = [];
        for (var image in images) {
          if (image != null) {
            String url =
                await cloud().uploadImageToDatabase(image: image, uid: uid);
            imageUrls.add(url);
          }
        }

        String productId = firebaseFirestore.collection('products').doc().id;
        await firebaseFirestore
            .collection('addTocart')
            .doc(currentUser.uid)
            .collection("products")
            .doc(productId)
            .set({
          'productName': title,
          'description': desc,
          'price': cost,
          'type': type,
          'imageUrls': imageUrls,
          'quantity': 1,
        });

        output = "success";
      } catch (e) {
        output = e.toString();
      }
    } else {
      output = "Please make sure all the fields are not empty";
    }

    return output;
  }

  Future<String> uploadImageToDatabase(
      {required Uint8List image, required String uid}) async {
    Reference storageRef =
        FirebaseStorage.instance.ref().child("products").child(uid);
    UploadTask uploadToask = storageRef.putData(image);
    TaskSnapshot task = await uploadToask;
    return task.ref.getDownloadURL();
  }

// profilePic
  Future<String> ProfilePic({
    required Uint8List file,
    required String uid,
  }) async {
    User currentUser = firebaseAuth.currentUser!;

    String url = await uploadProfileToStorage(file, false, currentUser.uid);
    Pic pic = Pic(id: currentUser.uid, photoUrl: url);
    await firebaseFirestore
        .collection("users")
        .doc(currentUser.uid)
        .update(pic.toJson());
    print(url);
    return url;
  }

  // Future<void> saveType(String type) async {
  //   try {
  //     String uid = cMethod.getUid();
  //     DocumentReference docRef =
  //         firebaseFirestore.collection('products').doc(uid);

  //     // Check if the document exists before updating
  //     DocumentSnapshot doc = await docRef.get();
  //     if (doc.exists) {
  //       await docRef.update({'type': type});
  //     } else {
  //       throw "Document does not exist";
  //     }
  //   } catch (e) {
  //     print("Error saving type: $e");
  //     throw e;
  //   }
  // }

  Future<String> uploadProductToDatabase({
    required String type,
    required List<Uint8List?> images,
    required String productName,
    required String rawCost,
    required description,
    required String quantity,
  }) async {
    description = description.trim();
    productName = productName.trim();
    rawCost = rawCost.trim();
    String output = "Something went wrong";

    if (images.isNotEmpty &&
        quantity.isNotEmpty &&
        productName.isNotEmpty &&
        rawCost.isNotEmpty) {
      try {
        String docid = firebaseFirestore.collection("products").doc().id;
        String uid = cMethod.getUid();
        List<String> imageUrls = [];
        for (var image in images) {
          if (image != null) {
            String url = await uploadImageToDatabase(image: image, uid: uid);
            imageUrls.add(url);
          }
        }
        double cost = double.parse(rawCost);

        ProductModel product = ProductModel(
            type: type,
            quantity: quantity,
            createdAT: DateTime.now(),
            uid: docid,
            imageUrls: imageUrls,
            productName: productName,
            cost: cost,
            description: description);

        await firebaseFirestore
            .collection("products")
            .doc(docid)
            .set(product.toMap());
        output = "success";
      } catch (e) {
        output = e.toString();
      }
    } else {
      output = "Please make sure all the fields are not empty";
    }

    return output;
  }

  static Future<List<ProductModel>> searchproduct(String product) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where("productName", isGreaterThanOrEqualTo: product)
        .get();

    return snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.data()))
        .toList();
  }

  // Future order(Map<String, dynamic> userInfo) async {
  //   return await FirebaseFirestore.instance.collection("ORDERS").add(userInfo);
  // }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String uid;
  String type;
  String productName;
  double cost;
  String description;
  String quantity;
  DateTime createdAT;
  List<String> imageUrls;

  ProductModel({
    this.uid = '',
    this.type = '',
    this.productName = '',
    this.cost = 0.0,
    this.description = '',
    this.quantity = '',
    required this.createdAT,
    this.imageUrls = const [],
  });

  factory ProductModel.fromMap(Map<String, dynamic> data) {
    // Handle createdAT field as either a Timestamp or an int
    DateTime createdAt;
    if (data['createdAT'] is Timestamp) {
      createdAt = (data['createdAT'] as Timestamp).toDate();
    } else if (data['createdAT'] is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(data['createdAT']);
    } else {
      createdAt = DateTime.now(); // Default value if neither type is matched
    }

    return ProductModel(
      uid: data['uid'] ?? '',
      type: data['type'] ?? '',
      productName: data['productName'] ?? '',
      cost: (data['cost'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      quantity: data['quantity'] ?? '',
      createdAT: createdAt,
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'type': type,
      'productName': productName,
      'cost': cost,
      'description': description,
      'quantity': quantity,
      'createdAT': createdAT,
      'imageUrls': imageUrls,
    };
  }
}

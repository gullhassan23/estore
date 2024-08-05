// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String name;
  String address;
  String uid;
  String email;
  String password;
  String photoUrl;
  DateTime lastActive;
  String phone;

  Users({
    required this.lastActive,
    this.name = "",
    this.address = '',
    this.uid = "",
    this.email = "",
    this.password = "",
    this.photoUrl = '',
    this.phone = '',
  });

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
        lastActive: map['lastActive'] != null
            ? (map['lastActive'] as Timestamp).toDate()
            : DateTime.now(),
        email: map['email'] ?? '',
        password: map['password'] ?? '',
        photoUrl: map['photoUrl'] ?? '',
        name: map['name'] ?? '',
        uid: map['uid'] ?? '',
        address: map['address'] ?? '',
        phone: map['phone'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      'lastActive': lastActive,
      'email': email,
      'password': password,
      'photoUrl': photoUrl,
      'phone': phone,
      'address': address,
      'uid': uid,
      'name': name
    };
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estore2/MODELS/AdminModel.dart';
import 'package:estore2/MODELS/UserModel.dart';
import 'package:estore2/Views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var user = Users(
    lastActive: DateTime.now(),
    name: '',
    email: '',
    password: '',
    photoUrl: '',
    phone: '',
  ).obs;
  Users? _userModel;
  var admin = Admin(
    AlastActive: DateTime.now(),
    Aemail: '',
    Apassword: '',
    Aname: '',
  ).obs;
  var isLoading = false.obs;
  Users? get userModel => _userModel;
  Admin? get adminModel => adminModel;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUserData();
      saveUserToken();
      fetchUserProfile();
    });
  }

  Future<void> fetchUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print("No user is currently signed in.");
        return;
      }

      String uid = currentUser.uid;
      print("Fetching data for user with UID: $uid");

      DocumentSnapshot userSnap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userSnap.exists) {
        user.value = Users.fromMap(userSnap.data() as Map<String, dynamic>);
        print("User data found: ${user.value.name}");
      } else {
        print("No user data found for UID: $uid");
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print("Error fetching user data: $e");
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print("No user is currently signed in.");
        return;
      }

      String uid = currentUser.uid;
      print("Fetching profile for user with UID: $uid");

      DocumentSnapshot userSnap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userSnap.exists) {
        user.value = Users.fromMap(userSnap.data() as Map<String, dynamic>);
        print("User profile data found: ${user.value.name}");
      } else {
        print("No user profile data found for UID: $uid");
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print("Error fetching user profile: $e");
    }
  }

  Future<void> saveUserToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && token != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'fcmToken': token,
      });
    }
  }

  Future<void> updateUserAddress(String newAddress) async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .update({'address': newAddress});
    user.update((val) {
      val?.address = newAddress;
    });
  }

  Future<void> updateUserPhone(String newPhone) async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .update({'phone': newPhone});
    user.update((val) {
      val?.phone = newPhone;
    });
  }

  void getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    print("Device Token: $token");
  }

  Future<void> logout(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.signOut().then((value) {
        Get.offAll(() => Login());
      });
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', e.toString());
    }
  }
}

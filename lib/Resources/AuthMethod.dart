import 'dart:typed_data';

import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estore2/MODELS/AdminModel.dart';
import 'package:estore2/MODELS/PicModel.dart';
import 'package:estore2/MODELS/UserModel.dart';
import 'package:estore2/Resources/cloud.dart';
import 'package:estore2/widgets/BAR.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

class Authenticationclass {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String adminEmail = 'admin@example.com';
  final String adminPassword = 'admin123';
  final String adminName = "HASSAN";
  final String adminPhone = "+923351764911";
  GoogleSignIn googleSignIn = GoogleSignIn();
  Future<Users> getUserDetails() async {
    User currentUser = auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return Users.fromMap(snap as Map<String, dynamic>);
  }

  Future<String> signUpUser(
      {required String name,
      required String phone,
      required String email,
      required String address,
      required String password}) async {
    name.trim();
    phone.trim();
    address.trim();
    email.trim();
    password.trim();
    String output = "Something went wrong";
    if (name != "" &&
        phone != "" &&
        email != "" &&
        address != "" &&
        password != "") {
      try {
        UserCredential cred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String salt = BCrypt.gensalt();
        String hashedPassword = BCrypt.hashpw(password, salt);
        print(hashedPassword);
        print(cred.user!.uid);
        Users user = Users(
          lastActive: DateTime.now(),
          email: email,
          address: address,
          password: hashedPassword,
          phone: phone,
          name: name,
          uid: cred.user!.uid,
        );

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toMap());
        // await cloud().uploadUserDataToFireStore(user: user);
        output = "success";
      } on FirebaseAuthException catch (e) {
        output = e.message.toString();
      }
    } else {
      output = "Please fill up all the fields.";
    }
    return output;
  }

  Future<String> signInUser(
      {required String email, required String password}) async {
    email.trim();
    password.trim();
    String output = "Something went wrong";
    if (email != "" && password != "") {
      try {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        output = "success";
      } on FirebaseAuthException catch (e) {
        output = e.message.toString();
      }
    } else {
      output = "Please fill up alll the fields.";
    }

    return output;
  }

  Future<String> signUpAdmin(
      {required String name,
      required String phone,
      required String email,
      required String password}) async {
    name.trim();
    phone.trim();
    email.trim();
    password.trim();
    String output = "Something went wrong";
    if (name == adminName &&
        phone == adminPhone &&
        email == adminEmail &&
        password == adminPassword) {
      try {
        UserCredential admincred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // String salt = BCrypt.gensalt();
        // String hashedPassword = BCrypt.hashpw(password, salt);
        // print(hashedPassword);
        print(admincred.user!.uid);
        Admin admin = Admin(
            isAdmin: true,
            AlastActive: DateTime.now(),
            Aemail: email,
            Aname: name,
            Apassword: password,
            Aphone: phone,
            Auid: admincred.user!.uid);

        await _firestore
            .collection('Admin')
            .doc(admincred.user!.uid)
            .set(admin.toMap());
        // await cloud().uploadUserDataToFireStore(user: user);
        output = "success";
      } on FirebaseAuthException catch (e) {
        output = e.message.toString();
      }
    } else {
      output = "Please fill up all the fields.";
    }
    return output;
  }

  Future<String> signInAdminUser(
      {required String email, required String password}) async {
    email.trim();
    password.trim();
    String output = "Something went wrong";
    if (email == adminEmail && password == adminPassword) {
      try {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        output = "success";
      } on FirebaseAuthException catch (e) {
        output = e.message.toString();
      }
    } else {
      output = "Please fill up alll the fields.";
    }

    return output;
  }

  // Future<void> Logout(BuildContext context) async {
  //   FirebaseAuth _auth = FirebaseAuth.instance;
  //   try {
  //     await _auth.signOut().then((value) {
  //       // Navigator.pushReplacement(
  //       //     context, MaterialPageRoute(builder: (context) => Login()));
  //       Get.offAll(() => Login());
  //     });
  //   } catch (e) {
  //     print("error");
  //   }
  // }

  Future<String> ProfilePic({
    required Uint8List file,
    required String uid,
  }) async {
    User currentUser = auth.currentUser!;
    String url =
        await cloud().uploadProfileToStorage(file, false, currentUser.uid);

    Pic pic = Pic(id: currentUser.uid, photoUrl: url);
    await _firestore
        .collection("users")
        .doc(currentUser.uid)
        .update(pic.toJson());
    print(url);

    return url;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  Future<void> addGoogleDataToFirestore(User user) async {
    try {
      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');
      final userDoc = await usersCollection.doc(user.uid).get();
      if (userDoc.exists) {
        print('Data already exists in Firestore. Skipping update.');
      } else {
        await usersCollection.doc(user.uid).set({
          'created': DateTime.now(),
          'name': user.displayName,
          'email': user.email,
          'photoUrl': user.photoURL,
          'uid': user.uid,
        });

        print('Data added to Firestore');
      }
    } catch (e) {
      print('Error adding/updating data in Firestore: $e');
    }
  }

  Future<void> handleGoogleSignIn(BuildContext context) async {
    final UserCredential? userCredential = await signInWithGoogle();
    if (userCredential != null) {
      final user = userCredential.user;

      await addGoogleDataToFirestore(user!);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Success'),
            content: Text('Logged in with Google successfully.'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomW(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }
}

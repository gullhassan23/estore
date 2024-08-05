import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Admin {
  String Aname;
  bool isAdmin;
  String Auid;
  String Aemail;
  String Apassword;

  DateTime AlastActive;
  String Aphone;
  Admin({
    this.Aname = '',
    this.isAdmin = false,
    this.Auid = '',
    this.Aemail = '',
    this.Apassword = '',
    required this.AlastActive,
    this.Aphone = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Aname': Aname,
      'isAdmin': isAdmin,
      'Auid': Auid,
      'Aemail': Aemail,
      'Apassword': Apassword,
      'AlastActive': AlastActive.millisecondsSinceEpoch,
      'Aphone': Aphone,
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    DateTime AlastActive;
    if (map['createdAT'] is Timestamp) {
      AlastActive = (map['AlastActive'] as Timestamp).toDate();
    } else if (map['AlastActive'] is int) {
      AlastActive = DateTime.fromMillisecondsSinceEpoch(map['AlastActive']);
    } else {
      AlastActive = DateTime.now(); // Default value if neither type is matched
    }
    return Admin(
      Aname: map['Aname'] as String,
      isAdmin: map['isAdmin'] as bool,
      Auid: map['Auid'] as String,
      Aemail: map['Aemail'] as String,
      Apassword: map['Apassword'] as String,
      AlastActive: AlastActive,
      Aphone: map['Aphone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Admin.fromJson(String source) =>
      Admin.fromMap(json.decode(source) as Map<String, dynamic>);
}

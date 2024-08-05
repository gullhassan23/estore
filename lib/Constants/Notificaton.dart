// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:estore/Views/home.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http;

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'package:flutter/services.dart' show rootBundle;

// class NotificationSService {
//   static Future<String> getAccessToken() async {
//     final serviceAccountJson =
//         await rootBundle.loadString('assets/file/file.json');
//     final accountCredentials =
//         auth.ServiceAccountCredentials.fromJson(jsonDecode(serviceAccountJson));
//     final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

//     final client =
//         await auth.clientViaServiceAccount(accountCredentials, scopes);
//     final credentials = await client.credentials;
//     return credentials.accessToken.data;
//   }

//   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   String receiverToken = '';

//   void initLocalNotification() {
//     const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosSettings = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestCriticalPermission: true,
//       requestSoundPermission: true,
//     );
//     const initializationSetting =
//         InitializationSettings(android: androidSetting, iOS: iosSettings);

//     flutterLocalNotificationsPlugin.initialize(initializationSetting,
//         onDidReceiveNotificationResponse: (response) {
//       debugPrint(response.payload.toString());
//     });
//   }

//   Future<void> sHoWlOcAlNoTiFiCaTiOn(RemoteMessage message) async {
//     final styleInformation = BigTextStyleInformation(
//       message.notification!.body.toString(),
//       htmlFormatBigText: true,
//       contentTitle: message.notification!.title,
//       htmlFormatTitle: true,
//     );
//     final androidDetails = AndroidNotificationDetails(
//       message.notification!.android!.channelId.toString(),
//       message.notification!.android!.channelId.toString(),
//       importance: Importance.max,
//       priority: Priority.max,
//       styleInformation: styleInformation,
//       playSound: true,
//       sound: const RawResourceAndroidNotificationSound('jetsons_doorbell'),
//     );
//     const iosDetails =
//         DarwinNotificationDetails(presentAlert: true, presentBadge: true);

//     final notificationDetails =
//         NotificationDetails(android: androidDetails, iOS: iosDetails);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       message.notification!.title,
//       message.notification!.body,
//       notificationDetails,
//       payload: message.data['body'],
//     );
//   }

//   Future<void> requestPermission() async {
//     final messaging = FirebaseMessaging.instance;
//     final settings = await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       debugPrint("USER GRANTED PERMISSION");
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       debugPrint("USER GRANTED PROVISIONAL PERMISSION");
//     } else {
//       debugPrint("USER DENIED PERMISSION");
//     }
//   }

//   Future<void> sAvEtOkEn(String token) async {
//     if (token.isNotEmpty) {
//       var currentUser = FirebaseAuth.instance.currentUser;

//       if (currentUser != null) {
//         var tokens =
//             FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

//         await tokens.set({
//           'token': token,
//         }, SetOptions(merge: true));
//       } else {
//         // Handle the case where the user is not logged in
//         debugPrint("Error: No user is currently logged in.");
//       }
//     }
//   }

//   Future<void> getToken() async {
//     final token = await FirebaseMessaging.instance.getToken();
//     print("token of device $token");
//     if (token != null) {
//       await sAvEtOkEn(token);
//     } else {
//       // Handle the case where token is null
//       debugPrint("Error: Failed to retrieve FCM token.");
//     }
//   }

//   Future<void> getRecieverToken(String? receiverID) async {
//     try {
//       final getToken = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(receiverID)
//           .get();

//       if (getToken.exists) {
//         final data = getToken.data();
//         if (data != null && data.containsKey('token')) {
//           receiverToken = data['token'];
//         } else {
//           debugPrint("Warning: 'token' field does not exist in the document.");
//         }
//       } else {
//         debugPrint("Error: Document does not exist.");
//       }
//     } catch (e) {
//       debugPrint("Error retrieving receiver token: $e");
//     }
//   }

//   void firebaseNotification(context) {
//     initLocalNotification();

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//       await Navigator.push(
//           context, MaterialPageRoute(builder: (context) => HOME()));
//     });

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       await sHoWlOcAlNoTiFiCaTiOn(message);
//     });
//   }

//   Future<void> sEnDNotIfication(String body, String senderID) async {
//     try {
//       final accessToken = await getAccessToken();
//       final response = await http.post(
//         Uri.parse(
//             'https://fcm.googleapis.com/v1/projects/estore-474fa/messages:send'),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $accessToken',
//         },
//         body: jsonEncode(<String, dynamic>{
//           'message': {
//             'token': receiverToken,
//             'priority': 'high',
//             'notification': <String, dynamic>{
//               'body': body,
//               'title': 'New Message !',
//             },
//             'data': <String, String>{
//               'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//               'senderId': senderID,
//             },
//             'android': {
//               'priority': 'high',
//             }
//           }
//         }),
//       );
//       if (response.statusCode == 200) {
//         print("Notification sent successfully.");
//       } else {
//         print("Failed to send notification. Response: ${response.body}");
//       }
//     } catch (e) {
//       debugPrint("Error sending notification: $e");
//     }
//   }
// }

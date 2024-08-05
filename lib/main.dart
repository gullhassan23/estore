import 'package:estore2/Constants/Themes.dart';
import 'package:estore2/Controller/CartController.dart';
import 'package:estore2/Controller/OrderController.dart';
import 'package:estore2/Controller/ProductController.dart';
import 'package:estore2/Controller/UserController.dart';
import 'package:estore2/Controller/darkThemeController.dart';
import 'package:estore2/Views/login.dart';
import 'package:estore2/Views/onboarding.dart';
import 'package:estore2/widgets/BAR.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   await FirebaseMessaging.instance.getInitialMessage();
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51LYvOaG5oJVKdCdohaq2PoZRQfiMsxnFxdMXEKRRejxqi3J47f9ayTmrPHIWEelgADGiL9ZrysBM5TsMeUJg4LPS00urKX4NBZ";
  await Firebase.initializeApp();
  Get.lazyPut<UserController>(() => UserController());
  Get.lazyPut<ProductController>(() => ProductController());
  Get.lazyPut<CartController>(() => CartController());
  Get.lazyPut<OrderController>(() => OrderController());

  final darkThemeController = Get.put(DarkThemeController());
  await darkThemeController.loadTheme();
  // await NotificationSService.getAccessToken();
  // await NotificationSService().requestPermission();
  // await NotificationSService().getToken();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Check if the user has completed onboarding
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasCompletedOnboarding =
      prefs.getBool('hasCompletedOnboarding') ?? false;

  runApp(MyApp(hasCompletedOnboarding: hasCompletedOnboarding));
}

class MyApp extends StatelessWidget {
  final bool hasCompletedOnboarding;

  const MyApp({super.key, required this.hasCompletedOnboarding});

  @override
  Widget build(BuildContext context) {
    final DarkThemeController darkThemeController =
        Get.find<DarkThemeController>();
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          theme: Styles.themeData(darkThemeController.getDarkTheme, context),
          debugShowCheckedModeBanner: false,
          home: FirebaseAuth.instance.currentUser == null
              ? Login()
              : (hasCompletedOnboarding ? BottomW() : Onboarding()),
        );
      },
    );
  }
}

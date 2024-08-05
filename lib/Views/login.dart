import 'package:estore2/Controller/darkThemeController.dart';
import 'package:estore2/Resources/AuthMethod.dart';
import 'package:estore2/Resources/Functions.dart';
import 'package:estore2/Views/SignUp.dart';
import 'package:estore2/widgets/BAR.dart';
import 'package:estore2/widgets/admin/AdminBar.dart';
import 'package:estore2/widgets/customtextfield.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool visiblePassword = false;
  CommonFunctions cMethod = CommonFunctions();

  bool isLoad = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DarkThemeController darkController = Get.find<DarkThemeController>();
    // Initialize ScreenUtil
    ScreenUtil.init(context);

    return Obx(() {
      return Scaffold(
        backgroundColor:
            darkController.getDarkTheme ? Color(0xFF0a0d2c) : Color(0xfff2f2f2),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
              ),
              Align(
                child: SwitchListTile(
                  secondary: Icon(
                    darkController.getDarkTheme
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    color: darkController.getDarkTheme
                        ? Colors.white
                        : Colors.black,
                  ),
                  onChanged: (bool value) {
                    darkController.setDarkTheme = value;
                  },
                  value: darkController.getDarkTheme,
                ),
              ),
              SizedBox(
                height: 100.h,
              ),
              Center(
                child: Text("estore",
                    style: TextStyle(
                        color: darkController.getDarkTheme
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 34.sp)),
              ),
              SizedBox(
                height: 30.h,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextForms(
                        isPass: false,
                        textEditingController: emailController,
                        hintText: "email",
                        textInputType: TextInputType.emailAddress),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 38,
                        top: 20,
                        right: 38,
                      ),
                      child: TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter password";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  visiblePassword = !visiblePassword;
                                });
                              },
                              icon: Icon(
                                visiblePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: darkController.getDarkTheme
                                    ? Colors.orange
                                    : Colors.brown,
                              )),
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: darkController.getDarkTheme
                                ? Colors.orange
                                : Colors.brown,
                          ),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: Divider.createBorderSide(context)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: Divider.createBorderSide(context)),
                          filled: true,
                          contentPadding: const EdgeInsets.all(18),
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: !visiblePassword,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          // Implement Forgot Password functionality
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 40.w, top: 5.h),
                          child: Text(
                            "Forgot Password ?",
                            style: TextStyle(
                              color: darkController.getDarkTheme
                                  ? Colors.orange
                                  : Colors.brown,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: darkController.getDarkTheme
                          ? Colors.orange
                          : Colors.brown,
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(80),
                        vertical: ScreenUtil().setHeight(10),
                      )),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoad = true;
                      });

                      if (emailController.text ==
                              Authenticationclass().adminEmail &&
                          passwordController.text ==
                              Authenticationclass().adminPassword) {
                        String output =
                            await Authenticationclass().signInAdminUser(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        setState(() {
                          isLoad = false;
                        });
                        if (output == "success") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminBottomBar()));
                        } else {
                          cMethod.displaYSnacKBaR(output, context);
                        }
                      } else {
                        String output = await Authenticationclass().signInUser(
                            email: emailController.text,
                            password: passwordController.text);
                        setState(() {
                          isLoad = false;
                        });
                        if (output == "success") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BottomW()));
                        } else {
                          cMethod.displaYSnacKBaR(output, context);
                        }
                      }
                    }
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  )),
              SizedBox(
                height: 20.h,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: darkController.getDarkTheme
                          ? Colors.orange
                          : Colors.brown,
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(80),
                        vertical: ScreenUtil().setHeight(10),
                      )),
                  onPressed: () async {
                    setState(() {
                      isLoad = true;
                    });

                    await Authenticationclass().handleGoogleSignIn(context);

                    setState(() {
                      isLoad = false;
                    });
                  },
                  child: Text(
                    "Login with Google",
                    style: TextStyle(color: Colors.white),
                  )),
              SizedBox(
                height: 140.h,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Do you have an account?",
                      style: TextStyle(
                        color: darkController.getDarkTheme
                            ? Colors.white
                            : Colors.blue,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                          color: darkController.getDarkTheme
                              ? Colors.orange
                              : Colors.brown,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

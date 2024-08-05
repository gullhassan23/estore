import 'package:estore2/Resources/AuthMethod.dart';
import 'package:estore2/Resources/Functions.dart';
import 'package:estore2/Resources/share_pref.dart';
import 'package:estore2/Views/login.dart';
import 'package:estore2/widgets/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:intl_phone_field/intl_phone_field.dart';

import '../Controller/darkThemeController.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool visiblePassword = false;
  CommonFunctions cMethod = CommonFunctions();
  final TextEditingController phone = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoad = false;

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
  }

  void SignUp() async {
    setState(() {
      isLoad = true;
    });
    await SharedPreferenceHelper().saveUserEmail(email.text);
    await SharedPreferenceHelper().saveUserName(name.text);
    await SharedPreferenceHelper().saveUserPasscode(password.text);
    await SharedPreferenceHelper().saveUserPhoto(phone.text);
    await SharedPreferenceHelper().saveUserResidence(address.text);
    if (email.text == Authenticationclass().adminEmail &&
        password.text == Authenticationclass().adminPassword &&
        name.text == Authenticationclass().adminName &&
        phone.text == Authenticationclass().adminPhone) {
      String output = await Authenticationclass().signUpAdmin(
          name: name.text,
          phone: phone.text,
          email: email.text,
          password: password.text);
      setState(() {
        isLoad = false;
      });
      if (output == "success") {
        print("All good happening");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Login()));
      } else {
        //error
        cMethod.displaYSnacKBaR(output, context);
      }
    } else {
      String output = await Authenticationclass().signUpUser(
          name: name.text,
          address: address.text,
          phone: phone.text,
          email: email.text,
          password: password.text);
      setState(() {
        isLoad = false;
      });
      if (output == "success") {
        print("All good happening");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Login()));
      } else {
        //error
        cMethod.displaYSnacKBaR(output, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DarkThemeController darkController = Get.find<DarkThemeController>();
    // Initialize ScreenUtil
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor:
          darkController.getDarkTheme ? Color(0xFF0a0d2c) : Color(0xfff2f2f2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100.h, // Use ScreenUtil for height
            ),
            Center(
              child: Text("estore",
                  style: TextStyle(
                      color: darkController.getDarkTheme
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 34.sp)), // Use ScreenUtil for font size
            ),
            SizedBox(
              height: 30.h, // Use ScreenUtil for height
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextForms(
                        isPass: false,
                        textEditingController: name,
                        hintText: "name",
                        textInputType: TextInputType.name),
                    TextForms(
                        textEditingController: email,
                        hintText: "email",
                        textInputType: TextInputType.emailAddress),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 38,
                        top: 20,
                        right: 38,
                      ),
                      child: TextFormField(
                        controller: password,
                        validator: (value) {
                          if (value!.isEmpty) {
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
                        keyboardType: TextInputType.name,
                        obscureText: !visiblePassword,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 38,
                        top: 20,
                        right: 38,
                      ),
                      child: IntlPhoneField(
                        showCountryFlag: true,
                        dropdownIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey,
                        ),
                        decoration: InputDecoration(
                            hintText: "Phone Number",
                            hintStyle: TextStyle(
                              color: darkController.getDarkTheme
                                  ? Colors.orange
                                  : Colors.brown,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: Divider.createBorderSide(context)),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Color(0xfffd6f3e),
                            )),
                        initialCountryCode: "+92",
                        onChanged: (text) => setState(() {
                          phone.text = text.completeNumber;
                        }),
                      ),
                    ),
                    TextForms(
                        isPass: false,
                        textEditingController: address,
                        hintText: "Address",
                        textInputType: TextInputType.name),
                  ],
                )),
            SizedBox(
              height: 20.h,
            ),
            isLoad
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: darkController.getDarkTheme
                            ? Colors.orange
                            : Colors.brown,
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(
                              80), // Make horizontal padding responsive
                          vertical: ScreenUtil().setHeight(10),
                        )),
                    onPressed: SignUp,
                    child: Text(
                      "Sign up",
                      style: TextStyle(color: Colors.white),
                    )),
            SizedBox(
              height: 50.h,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: darkController.getDarkTheme
                          ? Colors.white
                          : Colors.blue,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text(
                      " Login",
                      style: TextStyle(color: Colors.orange),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

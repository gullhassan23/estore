import 'package:estore2/Constants/images.dart';
import 'package:estore2/Constants/textStyles.dart';
import 'package:estore2/widgets/BAR.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  Future<void> completeOnboarding(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedOnboarding', true);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => BottomW()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 235, 231),
      body: Container(
        margin: EdgeInsets.only(top: 50.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(Mainimages[1]),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Explore\n The Best\n Products",
                    style: texTsTyle.buildTextField(
                      Colors.black,
                      40.sp,
                    )),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => completeOnboarding(context),
                    child: Container(
                      margin: EdgeInsets.only(right: 20.w),
                      padding: EdgeInsets.only(
                          top: 20.h, bottom: 20.h, left: 20.w, right: 20.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Text("Next",
                          style: texTsTyle.buildTextField(
                            Colors.white,
                            20.sp,
                          )),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:estore2/Controller/darkThemeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final bool obscureText;
  final int lines;
  const CustomTextField({
    Key? key,
    required this.textEditingController,
    required this.hintText,
    required this.obscureText,
    this.lines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DarkThemeController darkController = Get.find<DarkThemeController>();
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 4),
      child: TextFormField(
        obscureText: obscureText,
        controller: textEditingController,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: darkController.getDarkTheme ? Colors.orange : Colors.black,
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(
              color: darkController.getDarkTheme ? Colors.orange : Colors.brown,
            )),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
              color: darkController.getDarkTheme ? Colors.orange : Colors.brown,
            ))),
        validator: (val) {
          if (val == null || val.isEmpty) {
            return "Enter yout $hintText";
          }
          return null;
        },
        maxLines: lines,
      ),
    );
  }
}

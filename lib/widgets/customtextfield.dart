import 'package:estore2/Controller/darkThemeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextForms extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;

  const TextForms({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DarkThemeController darkController = Get.find<DarkThemeController>();
    final inputborder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: Divider.createBorderSide(context));
    return Padding(
      padding: const EdgeInsets.only(
        left: 35,
        top: 20,
        right: 35,
      ),
      child: TextFormField(
        controller: textEditingController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter $hintText";
          }
          return null;
        },
        decoration: InputDecoration(
          hintStyle: TextStyle(
            color: darkController.getDarkTheme ? Colors.orange : Colors.brown,
          ),
          hintText: hintText,
          fillColor: Colors.white,
          border: inputborder,
          enabledBorder: inputborder,
          filled: true,
          contentPadding: const EdgeInsets.all(18),
        ),
        keyboardType: textInputType,
        obscureText: isPass,
      ),
    );
  }
}

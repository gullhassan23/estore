import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:estore2/Controller/ProductController.dart';
import 'package:estore2/Controller/UserController.dart';
import 'package:estore2/Controller/darkThemeController.dart';
import 'package:estore2/Resources/Functions.dart';
import 'package:estore2/widgets/admin/customtextField.dart';
import 'package:estore2/widgets/admin/customButton.dart';

import 'package:flutter/material.dart';
import "package:dotted_border/dotted_border.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddProduct extends StatefulWidget {
  static const String routeName = "/add-product";
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  CommonFunctions commonFunctions = CommonFunctions();
  UserController userController = Get.put(UserController());
  ProductController productController = Get.put(ProductController());
  final DarkThemeController darkController = Get.put(DarkThemeController());

  @override
  void dispose() {
    super.dispose();
    priceController.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
  }

  List<Uint8List> images = [];

  String category = 'headphone';
  List<String> productCategories = ['headphone', 'TV', 'MIC', 'LED'];

  void selectImages() async {
    var res = await pickproducts();
    setState(() {
      images = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor:
            darkController.getDarkTheme ? Color(0xFF0a0d2c) : Color(0xfff2f2f2),
        appBar: AppBar(
            backgroundColor: darkController.getDarkTheme
                ? Color(0xFF0a0d2c)
                : Color(0xfff2f2f2),
            actions: [
              Container(
                width: 150.w,
                child: SwitchListTile(
                  onChanged: (bool value) {
                    darkController.setDarkTheme = value;
                  },
                  value: darkController.getDarkTheme,
                ),
              ),
            ],
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: GestureDetector(
              onTap: () {
                userController.logout(context);
              },
              child: Text(
                "Product Screen",
                style: TextStyle(
                    color: darkController.getDarkTheme
                        ? Color(0xfff2f2f2)
                        : Colors.black,
                    fontSize: 20.sp),
              ),
            )),
        body: SingleChildScrollView(
          child: Form(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                images.isNotEmpty
                    ? CarouselSlider(
                        items: images.map(
                          (i) {
                            return Builder(
                              builder: (BuildContext context) => Image.memory(
                                i,
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                            );
                          },
                        ).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200,
                        ),
                      )
                    : GestureDetector(
                        onTap: selectImages,
                        child: DottedBorder(
                            color: darkController.getDarkTheme
                                ? Colors.orange
                                : Colors.brown,
                            borderType: BorderType.RRect,
                            radius: Radius.circular(10),
                            dashPattern: [10, 4],
                            strokeCap: StrokeCap.round,
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.folder_open,
                                    color: darkController.getDarkTheme
                                        ? Colors.orange
                                        : Colors.brown,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Select Product Images",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: darkController.getDarkTheme
                                          ? Colors.orange
                                          : Colors.brown,
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                SizedBox(
                  height: 30,
                ),
                CustomTextField(
                    textEditingController: productNameController,
                    hintText: "Product Name",
                    obscureText: false),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    textEditingController: descriptionController,
                    hintText: "Description",
                    lines: 7,
                    obscureText: false),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    textEditingController: priceController,
                    hintText: "Price",
                    obscureText: false),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    textEditingController: quantityController,
                    hintText: "Quantity",
                    obscureText: false),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: double.infinity,
                    child: DropdownButton(
                      dropdownColor: darkController.getDarkTheme
                          ? Colors.orange
                          : Color(0xfff2f2f2),
                      value: category,
                      icon: Icon(Icons.keyboard_arrow_down),
                      items: productCategories.map((String item) {
                        return DropdownMenuItem(
                          child: Text(
                            item,
                            style: TextStyle(
                              color: darkController.getDarkTheme
                                  ? Color(0xfff2f2f2)
                                  : Colors.black,
                            ),
                          ),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (String? newVal) {
                        if (newVal != null) {
                          setState(() {
                            category = newVal;
                          });
                          // cloud().saveType(newVal);
                        }
                      },
                    )),
                SizedBox(
                  height: 10,
                ),
                CustomButton(
                    text: "Sell",
                    ontap: () async {
                      String output =
                          await productController.productToFirestore(
                        type: category,
                        quantity: quantityController.text,
                        productName: productNameController.text,
                        rawCost: priceController.text,
                        description: descriptionController.text,
                        images: images,
                      );
                      if (output == "success") {
                        commonFunctions.displaYSnacKBaR(
                            "Posted Product", context);
                      } else {
                        commonFunctions.displaYSnacKBaR(output, context);
                      }
                    })
              ],
            ),
          )),
        ),
      );
    });
  }
}

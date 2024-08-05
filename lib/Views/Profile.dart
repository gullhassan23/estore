import 'dart:typed_data';
import 'package:estore2/Constants/images.dart';
import 'package:estore2/Constants/textStyles.dart';
import 'package:estore2/Controller/OrderController.dart';
import 'package:estore2/Controller/UserController.dart';
import 'package:estore2/Controller/darkThemeController.dart';
import 'package:estore2/Resources/Functions.dart';
import 'package:estore2/Resources/cloud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserController userController = Get.put(UserController());
  final OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    userController.fetchUserData();
    orderController.fetchOrdersData();
  }

  Uint8List? image;
  void selectImage() async {
    User currentUser = _auth.currentUser!;
    Uint8List im = await CommonFunctions().pickImage(ImageSource.gallery);

    setState(() {
      image = im;
    });

    String output =
        await cloud().ProfilePic(file: image!, uid: currentUser.uid);
    if (output == "success") {
      CommonFunctions().displaYSnacKBaR("Posted ProfilePicture", context);
    } else {
      CommonFunctions()
          .displaYSnacKBaR("Profile picture cannot be posted", context);
    }
  }

  void showEditAddressDialog() {
    TextEditingController addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Address"),
          content: TextField(
            controller: addressController,
            decoration: InputDecoration(hintText: "Enter new address"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (addressController.text.isNotEmpty) {
                  await userController
                      .updateUserAddress(addressController.text);
                  Get.back();
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void showEditPhoneDialog() {
    TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Phone number"),
          content: TextField(
            controller: phoneController,
            decoration: InputDecoration(hintText: "Enter new Phone"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (phoneController.text.isNotEmpty) {
                  await userController.updateUserPhone(phoneController.text);
                  Get.back();
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final DarkThemeController darkController = Get.find<DarkThemeController>();
    return Obx(() {
      return Scaffold(
        backgroundColor:
            darkController.getDarkTheme ? Color(0xFF0a0d2c) : Color(0xfff2f2f2),
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: darkController.getDarkTheme
              ? Color(0xFF0a0d2c)
              : Color(0xfff2f2f2),
          title: Text(
            "Profile",
            style: texTsTyle.buildTextField(
                darkController.getDarkTheme ? Colors.white : Colors.black, 30),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Stack(
                  children: [
                    image != null
                        ? CircleAvatar(
                            radius: 64, backgroundImage: MemoryImage(image!))
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: AssetImage(Mainimages[0])),
                    Positioned(
                      top: 93,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: Icon(
                          Icons.edit,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                userController.user.value.name,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color:
                      darkController.getDarkTheme ? Colors.white : Colors.black,
                  fontSize: 20,
                ),
              ),
              Text(
                userController.user.value.email,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color:
                      darkController.getDarkTheme ? Colors.white : Colors.black,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              buildInfoRow(
                "Address",
                userController.user.value.address,
                showEditAddressDialog,
                darkController.getDarkTheme,
              ),
              buildInfoRow(
                "Phone number",
                userController.user.value.phone,
                showEditPhoneDialog,
                darkController.getDarkTheme,
              ),
              buildOrdersSection(),
              SwitchListTile(
                title: Text(
                  "Theme",
                  style: TextStyle(
                    fontSize: 24,
                    color: darkController.getDarkTheme
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                secondary: Icon(
                  darkController.getDarkTheme
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                  color:
                      darkController.getDarkTheme ? Colors.white : Colors.black,
                ),
                onChanged: (bool value) {
                  darkController.setDarkTheme = value;
                },
                value: darkController.getDarkTheme,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildInfoRow(
      String title, String value, VoidCallback onTap, bool isDarkTheme) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: texTsTyle.buildTextField(
                      isDarkTheme ? Colors.white : Colors.black, 20),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    value,
                    style: texTsTyle.buildTextField(
                        isDarkTheme ? Colors.white : Colors.black, 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrdersSection() {
    final DarkThemeController darkController = Get.find<DarkThemeController>();
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Orders",
                  style: texTsTyle.buildTextField(
                      darkController.getDarkTheme ? Colors.white : Colors.black,
                      20),
                ),
                Obx(() => Text(
                      "${orderController.orders.length}",
                      style: TextStyle(
                          color: darkController.getDarkTheme
                              ? Colors.white
                              : Colors.black,
                          fontSize: 20),
                    )),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: orderController.orders.length,
            itemBuilder: (context, index) {
              var order = orderController.orders[index];
              return ListTile(
                title: Text(
                  "Order ${order.productName}",
                  style: TextStyle(
                    color: darkController.getDarkTheme
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                subtitle: Text(
                  "Status: ${order.status}",
                  style: TextStyle(
                    color: darkController.getDarkTheme
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                trailing: Text(
                  "${order.orderDate.toLocal()}".split(' ')[0],
                  style: TextStyle(
                    color: darkController.getDarkTheme
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

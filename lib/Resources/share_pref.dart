import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  // static String userIdKey = "USERKEY";
  static String name = "username";
  static String address = "useraddress";

  static String email = "useraddress";
  static String password = "userpassword";
  static String photoUrl = "userImage ";
  static String phone = "usermobile";

  // Future<bool> saveUserID(String getUserId) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   return pref.setString(userIdKey, getUserId);
  // }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(name, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(email, getUserEmail);
  }

  Future<bool> saveUserPasscode(String getUserPasscode) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(password, getUserPasscode);
  }

  Future<bool> saveUserPhoto(String getUserPhoto) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(photoUrl, getUserPhoto);
  }

  Future<bool> saveUserMobile(String getUserCall) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(phone, getUserCall);
  }

  Future<bool> saveUserResidence(String getUserAddress) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(address, getUserAddress);
  }

  // get
  // Future<String?> getUserID() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   return pref.getString(userIdKey);
  // }

  Future<String?> getUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(name);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(email);
  }

  Future<String?> getUserPasscode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(password);
  }

  Future<String?> getUserPhoto() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(photoUrl);
  }

  Future<String?> getUserMobile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(phone);
  }

  Future<String?> getUserResidence() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(address);
  }
}

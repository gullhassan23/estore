import 'package:estore2/Resources/theme_pref.dart';
import 'package:get/get.dart';


class DarkThemeController extends GetxController {
  DarkThemePrefs darkThemePrefs = DarkThemePrefs();

  RxBool _darkTheme = false.obs;

  bool get getDarkTheme => _darkTheme.value;

  set setDarkTheme(bool value) {
    _darkTheme.value = value;
    darkThemePrefs.setDarkTheme(value);
  }

  Future<void> loadTheme() async {
    _darkTheme.value = await darkThemePrefs.getTheme();
  }
}

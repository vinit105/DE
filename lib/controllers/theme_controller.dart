import 'package:get/get.dart';

import '../utils/theme.dart';

class ThemeController extends GetxController {
  RxBool isDark = false.obs;

  changeTheme() {
    isDark.value = !isDark.value;
    Get.changeTheme(
      Get.isDarkMode ? lightTheme() : darkTheme(),
    );
  }
}

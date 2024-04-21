import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reminder_app_2/helpers/db_helper.dart';
import 'package:reminder_app_2/utils/theme.dart';
import 'package:reminder_app_2/views/screens/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DBHelper.dbHelper.fetchAllRecords();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      theme: lightTheme(),
      darkTheme: darkTheme(),
      getPages: [
        GetPage(name: "/", page: () => const HomePage()),
      ],
    );
  }
}

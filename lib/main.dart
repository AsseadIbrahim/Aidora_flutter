import 'package:first_flutter/Controlers/homecontroller.dart';
import 'package:first_flutter/Models/Org/OrgNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
// import 'package:http/http.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(FormController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: [GetPage(name: "/home", page: () => Orgnavigationbar())],
    );
  }
}

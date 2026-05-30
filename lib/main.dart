import 'package:first_flutter/Controlers/homecontroller.dart';
import 'package:first_flutter/Views/Org/OrgNavigationBar.dart';
import 'package:first_flutter/services/auth_service.dart';
import 'package:first_flutter/services/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(FormController());
  AuthStorage.init();
  await AuthService.instance.login(email: 'un@gmail.com', password: 'un1234');
  runApp(MyApp());
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

import 'package:first_flutter/Models/NavigationBar/All.dart';
import 'package:first_flutter/Models/NavigationBar/ProfilePage.dart';
// import 'package:first_flutter/Models/NavigationBar/dddddd.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:first_flutter/Controlers/homecontroller.dart';
import 'package:first_flutter/Models/NavigationBar/HomePage.dart';

// ignore: camel_case_types
class navigationbar extends StatelessWidget {
  navigationbar({super.key});

  final FormController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: const Color(0xffF4F6F5),
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: [HomePage(), A(), ProfilePage()],
        ),

        //  Bottom Navigation جاهز
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: (index) => controller.changePage(index),
          selectedItemColor: const Color.fromARGB(255, 3, 95, 6),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Tasks"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}

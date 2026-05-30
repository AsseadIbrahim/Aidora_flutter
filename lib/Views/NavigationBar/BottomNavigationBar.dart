import 'package:Aidora/Views/NavigationBar/AllTask.dart';
import 'package:Aidora/Views/NavigationBar/ProfilePage.dart';
// import 'package:Aidora/Models/NavigationBar/dddddd.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:Aidora/Controlers/homecontroller.dart';
import 'package:Aidora/Views/NavigationBar/HomePage.dart';

class Navigationbarr extends StatefulWidget {
  const Navigationbarr({super.key});

  @override
  State<StatefulWidget> createState() => _Navigationbar();
}

class _Navigationbar extends State<Navigationbarr> {
  final FormController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: const Color(0xffF4F6F5),
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: [HomePage(), Alltask(), ProfilePage()],
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

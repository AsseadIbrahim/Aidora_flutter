import 'package:Aidora/Views/Org/OrgFore/OrgFore.dart';
import 'package:Aidora/Views/Org/OrgOne/OrgOne.dart';
import 'package:Aidora/Views/Org/OrgThree/OrgThree.dart';
import 'package:Aidora/Views/Org/OrgTwo/OrgTwo.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:Aidora/Controlers/homecontroller.dart';
// import 'package:http/http.dart';

class Orgnavigationbar extends StatefulWidget {
  const Orgnavigationbar({super.key});
  @override
  State<StatefulWidget> createState() => _Orgnavigationbar();
}

class _Orgnavigationbar extends State<StatefulWidget> {
  final FormController controller = Get.put(FormController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  // CircleAvatar(child: Image.asset(
                  //  controller.listallpagetwo[0]['Organization_logo'] as String,
                  // ),),
                  Icon(Icons.crop_original, size: 35),
                  SizedBox(width: 20),
                  Text(
                    "Unisef",
                    style: TextStyle(fontSize: 30, color: Colors.blue),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_none),
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xffF4F6F5),

        body: IndexedStack(
          index: controller.orgCurrentIndex.value,
          children: [Orgone(), Orgtwo(), Orgthree(), Orgfore()],
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.orgCurrentIndex.value,
          onTap: (index) => controller.changOrgCurrentIndex(index),
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          unselectedFontSize: 15,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,

          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.switch_access_shortcut_add_outlined),
              label: "Assistance\nrequests",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_add),
              label: "Tasks",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.playlist_add_check_circle_sharp),
              label: "Volunteer\nrequests",
            ),
          ],
        ),
      ),
    );
  }
}

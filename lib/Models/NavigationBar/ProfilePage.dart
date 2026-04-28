import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:first_flutter/Controlers/homecontroller.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final FormController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _header(),
            _profileInfo(),
            _stats(),
            _skills(),
            _experience(),
            _logout(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Profile",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          IconButton(icon: Icon(Icons.qr_code_2), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _profileInfo() {
    return Column(
      children: [
        CircleAvatar(
          //child : هون بحط الصورة الشخصية
          radius: 40,
          child: Image.asset("images/Good team-cuate 1.png"),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Text(
            controller.userName.value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Obx(
          () => Text(
            "${controller.role.value} • ${controller.joinDate.value}",
            style: const TextStyle(color: Color.fromARGB(255, 23, 209, 39)),
          ),
        ),
      ],
    );
  }

  Widget _stats() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _card("Tasks", controller.tasks, Colors.blue.shade50),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _card("Points", controller.points, Colors.red.shade50),
          ),
        ],
      ),
    );
  }

  Widget _card(String title, RxInt value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(title),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              value.value.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _skills() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            "Skills & Badges",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),
          Obx(
            () => Wrap(
              spacing: 10,
              children: controller.skills
                  .map(
                    (e) => Chip(
                      label: Text(e),
                      backgroundColor: Colors.green.shade50,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _experience() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Previous experience",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => Column(
              children: controller.experiences
                  .map(
                    (e) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.volunteer_activism,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 10),
                          Text(e),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: controller.logout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade50,
          foregroundColor: Colors.red,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text("Log out"),
      ),
    );
  }
}

import 'dart:typed_data';
import 'package:first_flutter/Views/NavigationBar/AllTask.dart';
import 'package:first_flutter/services/api_constants.dart';
import 'package:first_flutter/services/api_service.dart';
import 'package:first_flutter/services/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:first_flutter/Controlers/homecontroller.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<StatefulWidget> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  final FormController controller = Get.find();
  Uint8List? imagebyte;
  String? imagename;
  XFile? image;
  var bytes;
  _updateImage() async {
    final XFile? image = await controller.picker.pickImage(
      source: ImageSource.gallery,
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    var res = await ApiService.instance.get(
      ApiConstants.profile,
      requiresAuth: true,
    );
    setState(() {
      controller.userName.value = res.data['full_name'];
      // controller.userImage.value = res.data['profile_image'];
      controller.joinDate.value = res.data['join_date'];
      controller.tasks.value = res.data['tasks_count'];
      controller.points.value = res.data['points'];
      controller.experiences.value = res.data['previous_experience'];
      controller.skills.assignAll(List<String>.from(res.data['skills']));
      controller.language.assignAll(List<String>.from(res.data['languages']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Profile",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            IconButton(icon: Icon(Icons.qr_code_2), onPressed: () {}),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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

  Widget _profileInfo() {
    return Column(
      children: [
        if (imagebyte != null)
          CircleAvatar(
            radius: 40,
            child: ClipOval(
              child: Image.memory(
                imagebyte!,
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              ),
            ),
          )
        else
          CircleAvatar(
            radius: 40,
            child: IconButton(
              onPressed: () {
                _updateImage();
              },
              icon: Icon(Icons.add),
            ),
          ),

        SizedBox(height: 10),
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
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Text("Tasks"),
                  SizedBox(height: 8),
                  Obx(
                    () => Text(
                      controller.tasks.value.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Text("Points"),
                  SizedBox(height: 8),
                  Obx(
                    () => Text(
                      controller.points.value.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
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
          const SizedBox(height: 10),
          Obx(
            () => Wrap(
              spacing: 10,
              children: controller.language
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
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.volunteer_activism, color: Colors.green),
                      const SizedBox(width: 10),
                      Text(controller.experiences.value),
                    ],
                  ),
                ),
              ],
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
        onPressed: () async {
          controller.isLoading.value = true;
          await ApiService.instance.post(
            ApiConstants.logout,
            requiresAuth: true,
            body: {"refresh": AuthStorage.getRefreshToken()},
          );
          controller.isLoading.value = false;
          Get.offAll(() => Alltask());
        },
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

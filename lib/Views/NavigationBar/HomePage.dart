import 'package:Aidora/services/api_constants.dart';
import 'package:Aidora/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:Aidora/Controlers/homecontroller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final FormController controller = Get.find();
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    var res = await ApiService.instance.get(
      ApiConstants.home,
      requiresAuth: true,
    );
    setState(() {
      controller.userName.value = res.data['full_name'];
      // controller.userImage = res.data['profile_image'];
      controller.failed.value = res.data['statistics']['failed'];
      controller.completed.value = res.data['statistics']['completed'];
      controller.pending.value = res.data['statistics']['pending'];
      controller.tasksthreeHome.assignAll(
        (res.data['recent_tasks'] as List).map(
          (e) => Map<String, Object>.from(e),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3EF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header
              _buildHeader(),
              const SizedBox(height: 20),
              const Text(
                "Home",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // 🔹 Cards
              _buildStats(),

              const SizedBox(height: 25),

              // 🔹 New Section
              _buildNewHeader(),

              const SizedBox(height: 10),

              // 🔹 List
              Expanded(child: _buildTaskList()),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // Header
  // =========================
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(radius: 22),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome back,",
                  style: TextStyle(color: Colors.grey),
                ),
                Obx(
                  () => Text(
                    controller.userName.value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none)),
      ],
    );
  }

  // =========================
  // Stats Cards
  // =========================
  Widget _buildStats() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _statCard(
                title: "Failed",
                value: controller.failed,
                color: Colors.red.shade100,
                textColor: Colors.red,
                icon: Icons.close,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _statCard(
                title: "Pending",
                value: controller.pending,
                color: Colors.orange.shade100,
                textColor: Colors.orange,
                icon: Icons.hourglass_bottom,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Center(
          child: SizedBox(
            width: 180,
            child: _statCard(
              title: "Completed",
              value: controller.completed,
              color: Colors.blue.shade100,
              textColor: Colors.blue,
              icon: Icons.check_circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required String title,
    required RxInt value,
    required Color color,
    required Color textColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: textColor),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(color: textColor)),
            const SizedBox(height: 5),
            Text(
              value.value.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // New Header
  // =========================
  Widget _buildNewHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "New",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {
            controller.currentIndex.value = 1;
          },
          child: Text("View All", style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }

  // =========================
  // Task List
  // =========================
  Widget _buildTaskList() {
    return Obx(
      () => ListView.builder(
        itemCount: controller.tasksthreeHome.length > 3
            ? 3
            : controller.tasksthreeHome.length,
        itemBuilder: (context, index) {
          var task = controller.tasksthreeHome[index];
          return _taskItem(task);
        },
      ),
    );
  }

  Widget _taskItem(Map task) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                controller.iconsMap[task['icon']]?.icon,
                color: controller.iconsMap[task['icon']]?.color,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task["title"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "${task["created_display"]} • ${task["location"]}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

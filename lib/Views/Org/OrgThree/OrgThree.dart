import 'package:first_flutter/Controlers/homecontroller.dart';
import 'package:first_flutter/Views/Org/AssignNewTask/AssignNewTask.dart';
import 'package:first_flutter/services/api_constants.dart';
import 'package:first_flutter/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';

class Orgthree extends StatefulWidget {
  const Orgthree({super.key});
  @override
  State<StatefulWidget> createState() => _Orgthree();
}

class _Orgthree extends State<StatefulWidget> {
  final FormController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Tasks',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Obx(() {
        if (controller.allTasks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // بطاقة الإحصائيات
                  _buildStatsCard(),
                  const SizedBox(height: 24),

                  ...controller.completedTasks
                      .map((task) => _buildTaskCard(task))
                      .toList(),

                  const SizedBox(height: 8),
                  ...controller.inProgressTasks
                      .map((task) => _buildTaskCard(task))
                      .toList(),

                  const SizedBox(height: 8),
                  ...controller.failedTasks
                      .map((task) => _buildTaskCard(task))
                      .toList(),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  onPressed: () {
                    Get.to(() => Assignnewtask());
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(
            'COMPLETED',
            controller.completedTasks.length,
            Colors.green,
          ),
          _statItem(
            'IN PROGRESS',
            controller.inProgressTasks.length,
            Colors.blue,
          ),
          _statItem('FAILED', controller.failedTasks.length, Colors.red),
        ],
      ),
    );
  }

  Widget _statItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    final bool isFailed = task.status == "failed";
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان والموقع
            Row(
              children: [
                Icon(
                  _getIconForStatus(task.status),
                  size: 20,
                  color: _getColorForStatus(task.status),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getColorForStatus(task.status)?.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _getColorForStatus(task.status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  task.location,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // المسؤول والتاريخ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task.assignee,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  task.date,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            // سبب الفشل إذا وجد
            if (isFailed && task.failureReason != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 18,
                      color: Colors.red.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '"${task.failureReason}"',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red.shade700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            // أزرار الإجراءات
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (task.status == "completed")
                  Expanded(
                    child: MaterialButton(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10),
                      ),
                      onPressed: () {},
                      child: Text(
                        "View Report",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                if (task.status == "failed")
                  MaterialButton(
                    color: const Color.fromARGB(255, 192, 191, 191),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                    onPressed: () {
                      task.status == "inProgress";
                    },
                    child: Text(
                      "    Reassign Task    ",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData? _getIconForStatus(String status) {
    switch (status) {
      case "completed":
        return Icons.check_circle_outline;
      case "inProgress":
        return Icons.pending_outlined;
      case "failed":
        return Icons.cancel_outlined;
    }
    return null;
  }

  Color? _getColorForStatus(String status) {
    switch (status) {
      case "completed":
        return Colors.green;
      case "inProgress":
        return Colors.blue;
      case "failed":
        return Colors.red;
    }
    return null;
  }
}

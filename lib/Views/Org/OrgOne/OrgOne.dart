import 'package:first_flutter/Controlers/homecontroller.dart';
import 'package:first_flutter/Views/Org/OrgOne/Report.dart';
import 'package:first_flutter/Views/Org/OrgTwo/DataPerson.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';

class Orgone extends StatelessWidget {
  Orgone({super.key});

  // تهيئة الـ Controller
  final FormController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم الإحصائيات
            Obx(
              () => Column(
                children: [
                  _buildStatCard(
                    title: 'New request',
                    value: controller.pageOne.value[0].approved,
                    color1: const Color(0xffffedd5),
                    color2: const Color(0xffea580c),
                    icon: Icons.note_add_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    title: 'In progress',
                    value: controller.pageOne.value[0].inProgress,
                    color1: const Color(0x440a94c2),
                    color2: const Color(0xff0a94c2),
                    icon: Icons.hourglass_bottom_rounded,
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    title: 'Completed',
                    value: controller.pageOne.value[0].completed,
                    color1: const Color(0xffdcfce7),
                    color2: const Color(0xff16a34a),
                    icon: Icons.check_circle_outline,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // عنوان "Recent New Requests" مع View All
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent New Requests',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    controller.orgCurrentIndex.value = 1;
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(color: Color(0xFF1CABE2)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // قائمة الطلبات الحديثة
            Obx(
              () => Column(
                children: controller.pageOne.value[0].requests.map((req) {
                  return _buildRecentRequestCard(req);
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // عنوان "Completed Tasks"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Completed Tasks',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text('Report Log', style: TextStyle(color: Colors.blue)),
              ],
            ),
            const SizedBox(height: 12),

            // قائمة المهام المكتملة
            Obx(
              () => Column(
                children: controller.pageOne.value[0].tasks.map((task) {
                  return _buildCompletedTaskCard(task);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت بطاقة إحصائية
  Widget _buildStatCard({
    required String title,
    required int value,
    required Color color1,
    required Color color2,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color1,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color2, size: 28),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                "$value",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ويدجت بطاقة طلب حديث
  Widget _buildRecentRequestCard(req) {
    Color typeColor;
    switch (req['state']) {
      case 'FOOD':
        typeColor = const Color.fromARGB(255, 233, 161, 67);
        break;
      case 'MEDICAL':
        typeColor = const Color.fromARGB(255, 14, 43, 80);
        break;
      case 'SHELTER':
        typeColor = const Color.fromARGB(255, 107, 9, 211);
        break;
      default:
        typeColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ID: ${req['id'] ?? 'Null'}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  req['type'] ?? '',
                  style: TextStyle(
                    color: typeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // تم تغليف هذا الجزء بـ Expanded لمنع مشاكل المساحة والـ ParentDataWidget
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        req['location'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.to(() => Dataperson());
                },
                icon: const Icon(Icons.arrow_forward_ios_rounded),
              ),
            ],
          ),
          Text(
            'Received on ${req['date'] ?? ''}',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ويدجت بطاقة مهمة مكتملة
  Widget _buildCompletedTaskCard(Map<String, dynamic> task) {
    bool state = task['report_reviewed'] ?? false;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xffdcfce7),
                    shape: BoxShape.circle,
                  ),
                  child: state
                      ? const Icon(Icons.check, color: Colors.green, size: 16)
                      : const Icon(Icons.task, color: Colors.green, size: 16),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task['title'] ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            task['id']?.toString() ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Vol: ${task['name'] ?? ''} . ${task['Country'] ?? ''}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${task['timedelay'] ?? ''}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          state
              ? const Icon(Icons.remove_red_eye)
              : TextButton(
                  onPressed: () {
                    Get.to(() => Report());
                  },
                  child: const Text("REPORT"),
                ),
        ],
      ),
    );
  }
}

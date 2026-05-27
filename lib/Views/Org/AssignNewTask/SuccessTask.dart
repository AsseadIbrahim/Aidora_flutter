import 'package:first_flutter/Controlers/homecontroller.dart';
import 'package:first_flutter/Views/Org/OrgNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';

class Successtask extends StatelessWidget {
  Successtask({super.key});

  // حقن المتحكم
  final FormController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Success"), centerTitle: true),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // قسم الأيقونة والعنوان
              successHeader(),
              const SizedBox(height: 32),
              // قسم بطاقة تفاصيل المهمة
              taskCard(),
              const SizedBox(height: 40),
              // قسم زر الانتقال إلى لوحة التحكم
              dashboardButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ========== قسم العنوان والأيقونة ==========
  Widget successHeader() {
    return Column(
      children: [
        // أيقونة النجاح
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle,
            color: Colors.green.shade700,
            size: 60,
          ),
        ),
        const SizedBox(height: 16),
        // عنوان "Success"
        Text(
          'Success',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade700,
          ),
        ),
        const SizedBox(height: 8),
        // رسالة "Task Assigned Successfully!"
        Text(
          'Task Assigned Successfully!',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 8),
        // نص ثانوي يوضح أنه تم إعلام Alex Rivera
        Text(
          'The task has been created and ${controller.reportID.value['full_name']} has been notified.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // ========== قسم بطاقة المهمة ==========
  Widget taskCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان "ASSIGNED TASK"
          Text(
            'ASSIGNED TASK',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          // عنوان المهمة مع أيقونة
          Row(
            children: [
              Icon(Icons.assignment, color: Colors.green.shade700, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  controller.taskTitleSuccess,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // صف التاريخ والوقت
          Row(
            children: [
              Icon(Icons.calendar_today, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                '${controller.taskDate} • ${controller.taskTime}',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // ========== قسم زر الانتقال إلى لوحة التحكم ==========

  Widget dashboardButton() {
    return ElevatedButton(
      onPressed: () {
        Get.offAll(() => Orgnavigationbar());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      child: const Text('Go to Dashboard'),
    );
  }
}

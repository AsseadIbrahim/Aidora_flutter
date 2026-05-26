import 'package:first_flutter/Controlers/homecontroller.dart';
import 'package:first_flutter/Views/Org/AssignNewTask/SuccessTask.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';

class Assignnewtask extends StatefulWidget {
  const Assignnewtask({super.key});
  @override
  State<StatefulWidget> createState() => _Assignnewtask();
}

class _Assignnewtask extends State<StatefulWidget> {
  String? route;
  @override
  void initState() {
    super.initState();
    setState(() {
      route = Get.previousRoute;
    });
  }

  // حقن المتحكم
  final FormController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Assign New Task'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: GetBuilder<FormController>(
        builder: (_) => Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // قسم: REQUEST معلومات
                  _buildRequestSection(controller),
                  const SizedBox(height: 24),

                  // قسم: Select volunteer (حقل بحث)
                  _buildVolunteerSearchSection(controller),
                  const SizedBox(height: 24),

                  // قسم: Task details
                  _buildTaskDetailsSection(controller),
                  const SizedBox(height: 32),

                  // أزرار: Create and Assign + Cancel
                  _buildActionButtons(controller),
                ],
              ),
            ),

            // مؤشر تحميل يظهر فوق المحتوى عند الضغط على إنشاء
          ],
        ),
      ),
    );
  }

  // ========== قسم معلومات الطلب ==========
  Widget _buildRequestSection(FormController controller) {
    if (route == "/Dataperson") {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'REQUEST: ${controller.requestId}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  controller.iconsMap[controller.logo]?.icon,
                  size: 18,
                  color: Colors.blue,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    controller.assistanceType,
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 18, color: Colors.blue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    controller.locations,
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Obx(
        () => DropdownButton<String>(
          isExpanded: true,
          itemHeight: null,
          hint: Text("Select User"),
          value: controller.valID.value.isEmpty ? null : controller.valID.value,

          items: controller.listallpagetwo.map((e) {
            return DropdownMenuItem<String>(
              value: e['id'],

              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      e['title'] ?? "",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      e['id'] ?? "",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),

                    SizedBox(height: 20),

                    Row(
                      children: [
                        Icon(
                          controller.iconsMap[e['icon']]?.icon,
                          color: Colors.lightBlue,
                        ),

                        SizedBox(width: 10),

                        Text(
                          e['taskName'] ?? "",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            controller.valID.value = value!;
          },
        ),
      );
    }
  }

  // ========== قسم البحث عن متطوع ==========
  Widget _buildVolunteerSearchSection(FormController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person_search_outlined, color: Colors.blue),
            SizedBox(width: 10),
            const Text(
              'Select volunteer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          onChanged: controller.updateSearch,
          decoration: InputDecoration(
            hintText: 'Search for a volunteer...',
            prefixIcon: const Icon(Icons.search, color: Colors.blueGrey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
        // يمكن إضافة قائمة نتائج البحث هنا مستقبلاً
      ],
    );
  }

  // ========== قسم تفاصيل المهمة ==========
  Widget _buildTaskDetailsSection(FormController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assignment, color: Colors.blue),
              SizedBox(width: 10),
              Text(
                'Task details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'TASK TITLE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            controller.taskTitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          Text(
            'DESCRIPTION/INSTRUCTION',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            controller.description,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ========== أزرار الإجراء ==========
  Widget _buildActionButtons(FormController controller) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Get.to(() => Successtask());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Create and Assign Task',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Get.back();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
              side: BorderSide(color: Colors.grey.shade300),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text('Cancel', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}

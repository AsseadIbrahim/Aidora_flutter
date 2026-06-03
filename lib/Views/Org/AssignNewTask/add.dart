import 'package:Aidora/Controlers/homecontroller.dart';
import 'package:Aidora/Views/Org/OrgNavigationBar.dart';
import 'package:Aidora/services/api_constants.dart';
import 'package:Aidora/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<StatefulWidget> createState() => _Add();
}

class _Add extends State<StatefulWidget> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    controller.taskTitle.clear();
    controller.description.clear();
  }

  Future<void> _init() async {
    try {
      var res = await ApiService.instance.get(
        ApiConstants.add,
        requiresAuth: true,
      );

      controller.serviceRequests.clear();
      setState(() {
        controller.serviceRequests.assignAll(
          (res.data['service_requests'] as List).map((e) {
            return {
              "id": e['id'],
              "refugee_name": e['refugee_name'] ?? '',
              "service_name": e['service_name'] ?? '',
              "service_icon": e['service_icon'] ?? '',
            };
          }).toList(),
        );
        controller.volunteersAssign.clear();
        controller.volunteersAssign.assignAll(
          (res.data['volunteers'] as List).map((e) {
            return {"id": e['id'], "full_name": e['full_name'] ?? ''};
          }).toList(),
        );
      });
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  // حقن المتحكم
  FormController controller = Get.find();

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم: REQUEST معلومات
            _buildRequestServiceRequests(),
            const SizedBox(height: 24),
            _buildRequestVolunteer(),
            const SizedBox(height: 20),

            // قسم: Task details
            _buildTaskDetailsSection(),
            const SizedBox(height: 32),
            // أزرار: Create and Assign + Cancel
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestServiceRequests() {
    return Obx(
      () => DropdownButton<String>(
        isExpanded: true,
        itemHeight: null,
        hint: Text("Select User"),
        value: controller.serviceRequestsID.value.isEmpty
            ? null
            : controller.serviceRequestsID.value,

        items: controller.serviceRequests.map((e) {
          return DropdownMenuItem<String>(
            value: e["id"].toString(),

            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5),

              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          e["refugee_name"].toString(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          e["id"].toString(),
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          controller.iconsMap[e["service_icon"]]?.icon,
                          color: controller.iconsMap[e["service_icon"]]?.color,
                        ),
                        SizedBox(width: 5),
                        Text(
                          e["service_name"].toString(),
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          controller.serviceRequestsID.value = value!;
        },
      ),
    );
  }

  Widget _buildRequestVolunteer() {
    return Obx(
      () => DropdownButton<String>(
        isExpanded: true,
        itemHeight: null,
        hint: Text("Select Volunteer"),
        value: controller.volunteersAssignID.value.isEmpty
            ? null
            : controller.volunteersAssignID.value,

        items: controller.volunteersAssign.map((e) {
          return DropdownMenuItem<String>(
            value: e["id"].toString(),

            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5),

              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e["full_name"].toString(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      e["id"].toString(),
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          controller.volunteersAssignID.value = value!;
        },
      ),
    );
  }

  // ========== قسم تفاصيل المهمة ==========
  Widget _buildTaskDetailsSection() {
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

          const SizedBox(height: 4),
          _section(
            title: "Task Title",
            child: _textField(
              controller: controller.taskTitle,
              hint: "Delivery of food basket to ${controller.requestId.value}",
              icon: Icons.task,
            ),
          ),
          SizedBox(height: 8),
          _section(
            title: "DESCRIPTION/INSTRUCTION",
            child: _textField(
              controller: controller.description,
              hint: "description",
              icon: Icons.description,
            ),
          ),
        ],
      ),
    );
  }

  // ========== أزرار الإجراء ==========
  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              controller.isLoading.value = true;
              await ApiService.instance.post(
                ApiConstants.add,
                requiresAuth: true,
                body: {
                  "service_request_id": int.parse(
                    controller.serviceRequestsID.value,
                  ),
                  "volunteer_id": int.parse(
                    controller.volunteersAssignID.value,
                  ),
                  "title": controller.taskTitle.text,
                  "instructions": controller.description.text,
                },
              );
              controller.isLoading.value = false;
              Get.snackbar(
                "Task Created",
                "Task created and assigned successfully.",
                colorText: Colors.green,
              );
              Get.offAll(() => Orgnavigationbar());
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
            child: controller.isLoading.value
                ? CircularProgressIndicator()
                : Text(
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

  // 🔹 Section (Reusable)
  Widget _section({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  // 🔹 TextField
  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xffF7F7F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xff7AD081)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: 2,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

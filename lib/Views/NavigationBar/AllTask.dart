// import 'package:first_flutter/Models/UpdateStatus/UpdateStatus.dart';
import 'package:first_flutter/Views/UpdateStatus/UpdateStatus.dart';
import 'package:first_flutter/services/api_constants.dart';
import 'package:first_flutter/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:first_flutter/Controlers/homecontroller.dart';

class Alltask extends StatefulWidget {
  const Alltask({super.key});
  @override
  State<StatefulWidget> createState() => _A();
}

class _A extends State<Alltask> {
  final FormController controller = Get.find();
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    var res = await ApiService.instance.get(
      ApiConstants.tasks,
      requiresAuth: true,
    );
    setState(() {
      controller.taskInTask.assignAll(
        res.data['results'].map<Map<String, Object>>((item) {
          Map<String, Object> newMap = {};

          item.forEach((key, value) {
            // إذا كانت القيمة null
            if (value == null) {
              newMap[key] = "";
            }
            // إذا كانت String
            else if (value is String) {
              newMap[key] = value;
            }
            // أي نوع آخر
            else {
              newMap[key] = value;
            }
          });

          return newMap;
        }).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Center(child: Text("All Tasks")),
            bottom: TabBar(
              tabs: [
                Tab(text: "All"),
                Tab(text: "Completed"),
                Tab(text: "Pending"),
                Tab(text: "Failed"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Expanded(child: _buildTaskList("")),
              Expanded(child: _buildTaskList("completed")),
              Expanded(child: _buildTaskList("pending")),
              Expanded(child: _buildTaskList("failed")),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // Task List
  // =========================
  Widget _buildTaskList(String s) {
    return Obx(
      () => ListView.builder(
        itemCount: controller.taskInTask.length,
        itemBuilder: (context, index) {
          late Map<String, Object> task = controller.taskInTask[index];
          if (s.isEmpty) {
            return _taskItem(task, index);
          }
          if (task['status'] == s) {
            return _taskItem(task, index);
          }
          return SizedBox(height: 0);
        },
      ),
    );
  }

  Widget _taskItem(Map task, int index) {
    return Card(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task["status"],
              style: TextStyle(
                color: task["status"] == "completed"
                    ? Colors.green
                    : (task["status"] == "pending"
                          ? Colors.orange
                          : Colors.red),
              ),
            ),
            SizedBox(height: 10),
            Text(
              task["title"],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.date_range),
                SizedBox(width: 5),
                Text(" ${task["created_at_display"]} "),
                Icon(Icons.circle, size: 7),
                Icon(Icons.location_on),
                Text(task["location"]),
              ],
            ),
            ListTile(
              subtitle: Text(
                task["status"] == "pending" ? "Sent ${task["time_ago"]}" : "",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
            if ((task["status"] == "pending" ||
                    task["status"] == "completed") &&
                task["status"] != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.to(() => Updatestatus(index: index));
                  },
                  child: Text("View Details"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

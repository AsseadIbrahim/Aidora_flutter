// import 'package:first_flutter/Models/UpdateStatus/UpdateStatus.dart';
import 'package:first_flutter/Models/UpdateStatus/UpdateStatus.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:first_flutter/Controlers/homecontroller.dart';

class A extends StatelessWidget {
  A({super.key});

  final FormController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
    );
  }

  // =========================
  // Task List
  // =========================
  Widget _buildTaskList(String s) {
    return Obx(
      () => ListView.builder(
        itemCount: controller.tasksthree.length,
        itemBuilder: (context, index) {
          late Map<String, String> task = controller.tasksthree[index];
          if (s.isEmpty) {
            return _taskItem(task, index);
          }
          if (task['state'] == s) {
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
              task["state"],
              style: TextStyle(
                color: task["state"] == "completed"
                    ? Colors.green
                    : (task["state"] == "pending" ? Colors.orange : Colors.red),
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
                Text(" ${task["date"]} "),
                Icon(Icons.circle, size: 7),
                Icon(Icons.location_on),
                Text(task["location"]),
              ],
            ),
            ListTile(
              subtitle: Text(
                task["state"] == "pending"
                    ? "Sent ${task["timeDelay"]}ago"
                    : "",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
            if ((task["state"] == "pending" || task["state"] == "completed") &&
                task["state"] != null)
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

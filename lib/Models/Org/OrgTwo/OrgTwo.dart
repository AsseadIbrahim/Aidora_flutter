import 'package:first_flutter/Controlers/homecontroller.dart';
import 'package:first_flutter/Models/Org/OrgTwo/DataPerson.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';

// ignore: must_be_immutable
class Orgtwo extends StatelessWidget {
  Orgtwo({super.key});
  final FormController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 5,
        child: Scaffold(
          backgroundColor: Color.fromARGB(240, 247, 242, 232),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(240, 247, 242, 232),
            title: Text(
              'Assistance requests',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),

            bottom: TabBar(
              isScrollable: true,
              indicator: ShapeDecoration(
                color: const Color.fromARGB(255, 148, 245, 139),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(50),
                ),
              ),
              tabs: [
                Tab(text: "     All     "),
                Tab(text: "   Completed   "),
                Tab(text: "   In review   "),
                Tab(text: "   Approve   "),
                Tab(text: "   Rejected   "),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Expanded(child: _buildTaskList("")),
              Expanded(child: _buildTaskList("completed")),
              Expanded(child: _buildTaskList("pending")),
              Expanded(child: _buildTaskList("approved")),
              Expanded(child: _buildTaskList("rejected")),
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
    return Obx(() {
      return ListView.builder(
        itemCount: controller.listallpagetwo.length,
        itemBuilder: (context, index) {
          var task = controller.listallpagetwo[index];
          if (s.isEmpty) {
            return _taskItem(task, index);
          }
          if (task['state'] == s) {
            return _taskItem(task, index);
          }
          return SizedBox(height: 0);
        },
      );
    });
  }

  Widget _taskItem(Map<String, String> task, int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  task['title'] ?? "NULL",
                  style: TextStyle(fontSize: 20),
                ),
                subtitle: Text(task['id'] ?? "NULL"),
                trailing: Container(
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: task['state'] == "completed"
                        ? Colors.green[200]
                        : task['state'] == "pending"
                        ? Colors.orange[200]
                        : task['state'] == "approved"
                        ? Colors.green[200]
                        : Colors.red[200],
                  ),
                  child: Center(
                    child: Text(
                      task['state'] ?? "NULL",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    controller.iconsMap[task['icon']]?.icon,
                    color: Colors.blue[100],
                  ),

                  SizedBox(width: 10),
                  Text(task['taskName'] ?? "NULL"),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.blue[100]),
                  SizedBox(width: 10),
                  Text(task["location"] ?? "NULL"),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.date_range_rounded, color: Colors.blue[100]),
                  SizedBox(width: 10),
                  Text(task['date'] ?? "NULL"),
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Get.to(() => Dataperson());
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Color(0xff5ba9c7),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "View Details",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

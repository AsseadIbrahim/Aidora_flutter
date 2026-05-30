import 'package:Aidora/Controlers/homecontroller.dart';
import 'package:Aidora/Views/Org/OrgTwo/DataPerson.dart';
import 'package:Aidora/services/api_constants.dart';
import 'package:Aidora/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';

class Orgtwo extends StatefulWidget {
  const Orgtwo({super.key});
  @override
  State<StatefulWidget> createState() => _Orgtwo();
}

// ignore: must_be_immutable
class _Orgtwo extends State<StatefulWidget> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    var res = await ApiService.instance.get(
      ApiConstants.orgPageTwo,
      requiresAuth: true,
    );
    setState(() {
      controller.listallpagetwo.assignAll(
        res.data.map<Map<String, String>>((item) {
          return {
            "ID": item["id"].toString(),
            "title": item["refugee_name"].toString(),
            "id": item["request_id"].toString(),
            "taskName": item["service_name"].toString(),
            "icon": item["icon"].toString(),
            "location": item["location"].toString(),
            "date": item["request_date"].toString(),
            "state": item["status"].toString(),
          };
        }).toList(),
      );
    });
  }

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
              _buildTaskList(""),
              _buildTaskList("completed"),
              _buildTaskList("pending"),
              _buildTaskList("approved"),
              _buildTaskList("rejected"),
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
        itemCount: controller.listallpagetwo.value.length,
        itemBuilder: (context, index) {
          var task = controller.listallpagetwo.value[index];
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
                    Get.to(
                      () => Dataperson(),
                      arguments: int.parse(task['ID']!),
                    );
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

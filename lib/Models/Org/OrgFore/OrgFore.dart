import 'package:first_flutter/Controlers/homecontroller.dart';
import 'package:first_flutter/Models/Org/OrgFore/VolunteerDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';

class Orgfore extends StatelessWidget {
  Orgfore({super.key});
  final FormController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Color.fromARGB(240, 247, 242, 232),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(240, 247, 242, 232),
            title: Text(
              'Volunteer requests',
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
                Tab(text: "       All       "),
                Tab(text: "   Accepted   "),
                Tab(text: "   In review   "),
                Tab(text: "   Rejected   "),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Expanded(child: _buildTaskList("")),
              Expanded(child: _buildTaskList("accepted")),
              Expanded(child: _buildTaskList("pending")),
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
    return Obx(
      () => ListView.builder(
        itemCount: controller.listallpagefore.length,
        itemBuilder: (context, index) {
          late VolunteerPageFore task = controller.listallpagefore[index];
          if (s.isEmpty) {
            return _taskItem(task, index);
          }
          if (task.state == s) {
            return _taskItem(task, index);
          }
          return SizedBox(height: 0);
        },
      ),
    );
  }

  Widget _taskItem(VolunteerPageFore task, int index) {
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
                leading: CircleAvatar(
                  child: Icon(
                    controller.iconsMap[task.logo]?.icon,
                    color: Colors.blue,
                  ),
                ),
                title: Text(task.name, style: TextStyle(fontSize: 20)),
                subtitle: Text(task.helpProvided[0]),
                trailing: Container(
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.green,
                  ),
                  child: Center(
                    child: Text(
                      task.state,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.blue[100]),
                  SizedBox(width: 10),
                  Text(task.location),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.date_range_rounded, color: Colors.blue[100]),
                  SizedBox(width: 10),
                  Text(task.date),
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Get.to(() => VolunteerDetailScreen(index: index));
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "View Details",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios),
                      ],
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

import 'package:Aidora/Controlers/homecontroller.dart';
import 'package:Aidora/Views/Org/OrgFore/VolunteerDetailScreen.dart';
import 'package:Aidora/services/api_constants.dart';
import 'package:Aidora/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';

class Orgfore extends StatefulWidget {
  const Orgfore({super.key});
  @override
  State<StatefulWidget> createState() => _Orgfore();
}

class _Orgfore extends State<StatefulWidget> {
  final FormController controller = Get.find();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    var res = await ApiService.instance.get(
      ApiConstants.orgpagefore,
      requiresAuth: true,
    );
    setState(() {
      controller.listallpagefore.value = (res.data['applications'] as List).map(
        (e) {
          return VolunteerPageFore(
            logo: List<String>.from(e['service_icon'] ?? []),

            name: e['full_name'] ?? '',

            appliedTime: e['created_at'] ?? '',

            email: e['email'] ?? '',

            phone: e['phone_number'] ?? '',

            age:
                int.tryParse(e['age'].toString().replaceAll(' years', '')) ?? 0,

            location: e['current_city'] ?? '',

            idNumber: e['id'].toString(),

            nationality: e['nationality'] ?? '',

            days: e['availability_shift'] ?? '',

            availabilityDays: List<String>.from(e['available_days'] ?? []),

            date: e['created_at'] ?? '',

            startDate: e['start_date']?.toString() ?? '',

            duration: e['expected_duration'] ?? '',

            languages: List<String>.from(e['languages'] ?? []),

            experience: e['previous_experience'] ?? '',

            education: e['education_level'] ?? '',

            helpProvided: List<String>.from(e['service_name'] ?? []),

            emergencyContact: e['Emergency'] ?? '',

            reason: e['why_volunteer'] ?? '',

            state: e['status'] ?? '',
          );
        },
      ).toList();
    });
  }

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
                Tab(text: "   Approved   "),
                Tab(text: "   Pending   "),
                Tab(text: "   Rejected   "),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildTaskList(""),
              _buildTaskList("approved"),
              _buildTaskList("pending"),
              _buildTaskList("rejected"),

              // Expanded(child: _buildTaskList("")),
              // Expanded(child: _buildTaskList("approved")),
              // Expanded(child: _buildTaskList("pending")),
              // Expanded(child: _buildTaskList("rejected")),
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
                    controller.iconsMap[task.logo[0]]?.icon,
                    color: controller.iconsMap[task.logo[0]]?.color,
                  ),
                ),
                title: Text(task.name, style: TextStyle(fontSize: 20)),
                subtitle: Text(task.helpProvided[0]),
                trailing: Container(
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: task.state == "approved"
                        ? Colors.green
                        : (task.state == "pending"
                              ? Colors.orange
                              : Colors.red),
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
                    setState(() {});
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

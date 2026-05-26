import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:image_picker/image_picker.dart';

////////////////////// start class for page Form fore //////////////////////
class CategoryItem {
  String name;
  RxBool isSelected;
  int id;
  CategoryItem({
    required this.name,
    required this.isSelected,
    required this.id,
  });

  ////////////////////// end class for page Form fore //////////////////////
}

class DataProfile {
  // ************************** All Org Page profie in PageTwo  in org **************************
  String orgname;
  String orglogo;
  String fullName;
  String id;
  String task;
  String locationPersonProfile;
  String phoneNumber;
  int totalMembers;
  String urgencyLevel;
  String description;
  String status; // pending, approved, rejected
  DataProfile({
    required this.orgname,
    required this.orglogo,
    required this.fullName,
    required this.id,
    required this.task,
    required this.locationPersonProfile,
    required this.phoneNumber,
    required this.totalMembers,
    required this.urgencyLevel,
    required this.description,
    required this.status,
  });
}

class PageOneClass {
  int approved;
  int inProgress;
  int completed;
  List<Map<String, String>> requests;
  List<Map<String, dynamic>> tasks;

  PageOneClass({
    required this.approved,
    required this.inProgress,
    required this.completed,
    required this.requests,
    required this.tasks,
  });
}

class TaskModel {
  String id;
  String title;
  String location;
  String assignee;
  String date;
  String status;
  String? failureReason;

  TaskModel({
    required this.id,
    required this.title,
    required this.location,
    required this.assignee,
    required this.date,
    required this.status,
    this.failureReason,
  });
}

///////////////////////////////////////////////////////////////////////////////////
class VolunteerPageFore {
  List<String> logo;
  String name;
  String appliedTime;
  String email;
  String phone;
  int age;
  String location;
  String idNumber;
  String nationality;
  String days;
  List<String> availabilityDays;
  String date;
  String startDate;
  String duration;
  List<String> languages;
  String experience;
  String education;
  List<String> helpProvided;
  String emergencyContact;
  String reason;
  String state;

  VolunteerPageFore({
    required this.name,
    required this.appliedTime,
    required this.email,
    required this.phone,
    required this.age,
    required this.location,
    required this.idNumber,
    required this.nationality,
    required this.days,
    required this.availabilityDays,
    required this.date,
    required this.startDate,
    required this.duration,
    required this.languages,
    required this.experience,
    required this.education,
    required this.helpProvided,
    required this.emergencyContact,
    required this.reason,
    required this.state,
    required this.logo,
  });
}

class tasks {
  String title;
  String date;
  String timeDelay;
  String location;
  String icon;
  String state;
  String Organization;
  String Description;

  tasks({
    required this.title,
    required this.date,
    required this.timeDelay,
    required this.location,
    required this.icon,
    required this.state,
    required this.Organization,
    required this.Description,
  });
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class FormController extends GetxController {
  @override
  void onClose() {
    // one
    nationality.dispose();
    idController.dispose();
    cityController.dispose();
    // two
    startDate.dispose();
    expectedDuration.dispose();
    // three
    education.dispose();
    languagesThree.dispose();
    experienceController.dispose();
    skillsController.dispose();
    // five
    phoneNumberEmergency.dispose();
    volunteer.dispose();
    super.onClose();
  }

  var isLoading = false.obs;
  var isLoadingAccess = false.obs;
  var isLoadingReject = false.obs;

  // ************************** Page One **************************
  var month = 'Month'.obs;
  var day = 'Day'.obs;
  var year = 'Year'.obs;
  late var date = ''.obs;

  void returnDate(String year, int month, int day) {
    if (day >= 1 && day < 10) {
      if (month >= 1 && month < 10) {
        date.value = '$year-0$month-0$day';
      } else {
        date.value = '$year-$month-0$day';
      }
    } else {
      if (month >= 1 && month < 10) {
        date.value = '$year-0$month-$day';
      } else {
        date.value = '$year-$month-$day';
      }
    }
  }

  var gender = 'Select gender'.obs;

  final nationality = TextEditingController();
  final idController = TextEditingController();
  final cityController = TextEditingController();

  /// بيانات
  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final days = List.generate(31, (i) => (i + 1).toString());
  final years = List.generate(60, (i) => (2011 - i).toString());

  final genders = ['Male', 'Female'];

  void setMonth(String value) => month.value = value;
  void setDay(String value) => day.value = value;
  void setYear(String value) => year.value = value;
  void setGender(String value) => gender.value = value;

  // ************************** Page Two **************************

  // المتغيرات
  var selectedSchedule = ''.obs; // Morning, Afternoon, Evening
  var selectedDays = <String>[].obs; // الأيام المحددة
  final startDate = TextEditingController();
  final expectedDuration = TextEditingController();

  // قائمة الأيام المتاحة
  final List<String> availableDays = ['S', 'M', 'Tu', 'W', 'Th', 'F', 'Sa'];

  // دالة اختيار الجدول الزمني
  void selectSchedule(String schedule) {
    selectedSchedule.value = schedule;
  }

  // دالة اختيار/إلغاء اختيار اليوم
  void toggleDay(String day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day);
    } else {
      selectedDays.add(day);
    }
  }

  // ************************** Page Three **************************

  // 🔹 القيم
  // 🔹 TextFields
  final education = TextEditingController();
  final languagesThree = TextEditingController();
  final experienceController = TextEditingController();
  final skillsController = TextEditingController();

  // ************************** Page fore **************************
  var idOrganization = 1.obs;

  final List<CategoryItem> categories = [
    CategoryItem(name: 'Child protection', isSelected: false.obs, id: 1),
  ];

  void toggleSelection(int index) {
    categories[index].isSelected.value = !categories[index].isSelected.value;
  }

  List<String> getSelectedCategories() {
    return categories
        .where((item) => item.isSelected.value)
        .map((item) => item.name)
        .toList();
  }

  // ************************** Page five **************************
  // 🔹 TextFields
  final phoneNumberEmergency = TextEditingController();
  final volunteer = TextEditingController();

  //  متغيرات لتتبع حالة checkbox
  var isInfoAgreed = false.obs;
  var isPolicyCommitted = false.obs;
  // تحديث حالة الموافقة على استخدام المعلومات
  void toggleInfoAgreement(bool? value) {
    isInfoAgreed.value = value ?? false;
  }

  // تحديث حالة الموافقة على سياسة حماية الطفل
  void togglePolicyCommitment(bool? value) {
    isPolicyCommitted.value = value ?? false;
  }

  // ************************** PIN Number **************************
  var pinCode = ''.obs;

  // ************************** Profile **************************
  var role = "Verified Volunteer".obs;
  var joinDate = "".obs;

  // Stats
  var tasks = 42.obs;
  var points = 850.obs;

  // Skills
  var skills = ["First Aid", "Logistics"].obs;
  var language = ["arabic"].obs;
  // Experience
  var experiences = "Emergency Food Drive".obs;

  var currentIndex = 0.obs;

  void changePage(int index) => currentIndex.value = index;

  void logout() {
    Get.snackbar("Logout", "You have been logged out");
  }

  // ************************** Home **************************

  // اسم المستخدم
  var userName = "Alex Rivera".obs;
  final ImagePicker picker = ImagePicker();
  XFile? userImage;

  // الإحصائيات
  var failed = 4.obs;

  var pending = 6.obs;
  var completed = 24.obs;
  // قائمة المهام
  var tasksthreeHome = [
    {
      'id': 1,
      'title': 'mission',
      'location': 'homs',
      'created_display': '10:57 AM',
      'icon': 'school',
    },
  ].obs;

  void updateData(int index, String item, String rejectionReason) {
    taskInTask[index]['status'] = item;
    taskInTask[index]['rejection_reason'] = rejectionReason;
    taskInTask.refresh();
  }

  // ************************** All Tasks **************************
  var taskInTask = [
    {
      "id": 3,
      "title": "Medical Sorting",
      "status": "completed",
      "location": "homs",
      "created_at_display": "May 11, 08:36 PM",
      "task_description": "Urgent help",
      "organization_name": "UNICEF",
    },
  ].obs;

  var currentIndexAllTasks = 0.obs;
  void changePageAllTasks(int index) => currentIndexAllTasks.value = index;

  //Organization***Organization***Organization***Organization***Organization***Organization***Organization***Organization***Organization//

  // ************************** Organization **************************

  var orgCurrentIndex = 0.obs;
  void changOrgCurrentIndex(int index) => orgCurrentIndex.value = index;

  // ************************** All Org Page One **************************

  // ************************** All Org Page two **************************
  RxString valID = "".obs;
  List<Map<String, String>> listallpagetwo = [
    {
      "title": "Ahmad Youssef",
      "id": "R-12345",
      "taskPhoto": "images/my photo",
      "taskName": "Food assistance",
      'icon': 'restaurant',
      "location": "Homs-Al_waer",
      "date": "2025/12/10",
      "state": "completed",
    },
    {
      "title": "Sara Salloum",
      "id": "D-87543",
      "taskPhoto": "images/my",
      "taskName": "Medical aid",
      'icon': 'medical_services',
      "location": "Damascus",
      "date": "2025/11/10",
      "state": "pending",
    },
  ].obs;

  // ************************** All Org Page Three **************************

  // قوائم منفصلة لكل حالة (للاستدعاء السريع)
  final completedTasks = <TaskModel>[].obs;
  final inProgressTasks = <TaskModel>[].obs;
  final failedTasks = <TaskModel>[].obs;

  // بيانات تجريبية مطابقة للصورة
  final allTasks = [
    TaskModel(
      id: '1',
      title: 'Food Aid Distribution',
      location: 'Homs - Al-waer',
      assignee: 'Layla Mostafa',
      date: "Apr 9 ,2023",
      status: "completed",
    ),
    TaskModel(
      id: '2',
      title: 'Medical Supply Check',
      location: 'Aleppo - Center',
      assignee: 'Omar Khalid',
      date: "Dec 2 , 2025 ",
      status: "failed",
      failureReason:
          "The reason for the mission's failure is that the family was not at the mentioned location.",
    ),
    TaskModel(
      id: '3',
      title: 'Clean Water Access',
      location: 'Raqqa - East',
      assignee: 'Sarah Jenkins',
      date: "Oct 19 , 2022",
      status: "inProgress",
    ),
    TaskModel(
      id: '2',
      title: 'Medical Supply Check',
      location: 'Aleppo - Center',
      assignee: 'Omar Khalid',
      date: "Dec 2 , 2025 ",
      status: "failed",
      failureReason:
          "The reason for the mission's failure is that the family was not at the mentioned location.",
    ),
    TaskModel(
      id: '1',
      title: 'Food Aid Distribution',
      location: 'Homs - Al-waer',
      assignee: 'Layla Mostafa',
      date: "Apr 9 ,2023",
      status: "completed",
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _updateSeparateLists();
  }

  void _updateSeparateLists() {
    completedTasks.assignAll(allTasks.where((t) => t.status == "completed"));
    inProgressTasks.assignAll(allTasks.where((t) => t.status == "inProgress"));
    failedTasks.assignAll(allTasks.where((t) => t.status == "failed"));
  }
  // ************************** All Org Page fore **************************

  RxList<VolunteerPageFore> listallpagefore = [
    VolunteerPageFore(
      logo: ["medical_services"],
      name: 'Omar Al-Hassan',
      appliedTime: 'Applied 2 hours ago',
      email: 'omar.hassan@email.com',
      phone: '+971 50 123 4567',
      age: 24,
      location: 'Dubai, UAE',
      idNumber: '8821',
      nationality: 'Syrian',
      days: 'morning',
      availabilityDays: ['Sun', 'Mon', 'Thu'],
      date: 'Dec 16 , 2023',
      startDate: '5/12/2026',
      duration: '3 months',
      languages: ['English', 'Arabic'],
      experience: '2+ Years of project Mgmt, First Aid',
      education: 'Student',
      helpProvided: ['Health awareness', 'Child protection'],
      emergencyContact: '+968 3828378',
      reason: 'Because he loves helping others.',
      state: 'pending',
    ),
    VolunteerPageFore(
      logo: ['emergency'],
      name: 'Ali khador',
      appliedTime: 'Applied 3 hours ago',
      email: 'ali.khador@email.com',
      phone: '+971 92 684 8452',
      age: 20,
      location: 'Homs, Syria',
      idNumber: '8431',
      nationality: 'Syrian',
      days: 'morning',
      availabilityDays: ['Mon', 'thu', 'fr'],
      date: "Oct 22 , 2023",
      startDate: '19/11/2026',
      duration: '8 months',
      languages: ['English', 'Arabic'],
      experience: '4+ Years of project Mgmt, First Aid',
      education: 'Student',
      helpProvided: ['Health awareness', 'Child protection'],
      emergencyContact: '+968 3886578',
      reason: 'Because he loves helping others.',
      state: 'accepted',
    ),
  ].obs;

  void setStateVolunteer(int index, String state) {
    listallpagefore[index].state = state;
  }

  // ************************** All Org Page One **************************

  var pageOne = [
    PageOneClass(
      approved: 45,
      inProgress: 120,
      completed: 24,
      requests: [
        {
          'id': 'R-12345',
          'location': 'Homs, Syria',
          'date': '10/Dec/2025',
          'type': 'FOOD',
          'ID': "1",
        },
        {
          'id': 'D-67840',
          'location': 'Aleppo, Syria',
          'date': '12/Nov/2025',
          'type': 'MEDICAL',
          'ID': "2",
        },
        {
          'id': 'R-09643',
          'location': 'Damascus, Syria',
          'date': '3/Dec/2025',
          'type': 'SHELTER',
          'ID': "3",
        },
      ],
      tasks: [
        {
          'title': 'Food distribution',
          'id': '#12',
          'name': 'Ali A',
          'Country': 'Homs',
          'timedelay': '1h ago',
          'report_reviewed': true,
          "ID": 1,
        },
        {
          'title': 'Medical aid',
          'id': '#8',
          'name': 'Layla L',
          'Country': 'Aleppo',
          'timedelay': '4h ago',
          'report_reviewed': true,
          "ID": 2,
        },
        {
          'title': 'Aid Package Delivery',
          'id': 'R-09643',
          'name': 'Alex S',
          'Country': 'Damascus',
          'timedelay': '3h ago',
          'report_reviewed': false,
          "ID": 3,
        },
      ],
    ),
  ].obs;
  // ************************** All Org Page Report **************************
  // بيانات ثابتة (يمكن استبدالها بجلب من API)
  final String sectionTitle = "Aid Package Delivery";
  final String dateTime = "Thursday, Oct 24 • 10:00 AM";
  final String location = "Regional Distribution Hub";
  final String volunteerName = "Alex Rivera";
  final String taskDescription =
      "Responsible for the final mile delivery of essential aid packages to registered families. Ensure all items are accounted for and handle deliveries with care and respect for cultural norms.";

  // النقاط المختارة
  RxInt selectedPoints = 0.obs;

  /// اختيار نقاط الأداء
  void selectPoints(int points) {
    if (selectedPoints.value + points <= 10000) {
      selectedPoints.value += points;
    }
  }

  /// اختيار نقاط الأداء
  void updateValue(int points) {
    selectedPoints.value = points;
  }
  // ************************** All Org Page Card Person **************************

  final personOne = DataProfile(
    orgname: "DataProfile",
    orglogo: "images/MyImage",
    fullName: 'Ahmed Youssef',
    id: "R-15897",
    task: "Food Assistance",
    locationPersonProfile: "Al-Rimal District, Near Central Park",
    phoneNumber: "+963 934 555 123",
    totalMembers: 9,
    urgencyLevel: "Normal",
    description:
        'Requester is seeking urgent food assistance for a household of 9. '
        'Primary breadwinner is currently unable to work due to local displacement. '
        'Three children under the age of 10 are in the household. Immediate needs include basic staples and infant nutritional support.',
    status: "pending",
  );

  // متغير لتخزين نص سبب الفشل (عند اختيار Failed)
  var resonPersonOne = ''.obs;

  // دالة لتحديث سبب الفشل من المدخلات النصية
  void updateResonPersonOne(String reason) {
    resonPersonOne.value = reason;
  }
  //  ////////////////////////// Assign New Task  ////////////////////

  // بيانات ثابتة للعرض (يمكن جلبها من API)
  final String requestId = 'R-15897';
  final String logo = "restaurant";
  final String assistanceType = 'Food assistance';
  final String locations = 'Homs-Al-Waer';
  final String taskTitle = 'Delivery of food basket to R-15897';
  final String description =
      'Deliver the monthly food basket to the registered address. '
      'Ensure cultural sensitivity during the interaction and confirm identity upon arrival.';

  // حالة حقل البحث
  String searchQuery = '';

  // دالة تحديث البحث
  void updateSearch(String value) {
    searchQuery = value;
    update(); // تحديث واجهة GetBuilder
  }
  //  ////////////////////////// Success  Task ////////////////////

  // بيانات المهمة (يمكن جلبها من وسيط أو API)
  final String taskTitleSuccess = 'Community Garden Mulching';
  final String taskDate = 'Oct 24, 2023';
  final String taskTime = '9:00 AM';
  /////////////////////////////// ماب التحويل ///////////////////////////////
  List x = [
    {'title': 'assead', 'icon': 'Home'},
    {'title': 'ali', 'icon': 'Settings'},
    {'title': 'ahmad', 'icon': 'Add'},
  ];
  Map<String, IconConfig> iconsMap = {
    "emergency": IconConfig(Icons.emergency, Color(0xff15a3da)),
    "sos": IconConfig(Icons.sos, Colors.red),
    "coronavirus": IconConfig(Icons.coronavirus, Color(0xfff15f0b)),
    "local_hospital": IconConfig(Icons.local_hospital, Color(0xffdb08ee)),
    "vaccines": IconConfig(Icons.vaccines, Color(0xff26be0b)),
    "psychology": IconConfig(Icons.psychology, Color(0xffff2a95)),
    "groups_rounded": IconConfig(Icons.groups_rounded, Color(0xff1adf8a)),
    "medical_services": IconConfig(Icons.medical_services, Color(0xffe22121)),
    "restaurant": IconConfig(Icons.restaurant, Color(0xfff15f0b)),
    "warning": IconConfig(Icons.warning, Color(0xff26be0b)),
    "favorite": IconConfig(Icons.favorite, Color(0xffdb08ee)),
    "water_drop": IconConfig(Icons.water_drop, Color(0xff15a3da)),
    "school": IconConfig(Icons.school, Color(0xfff15f0b)),
    "health_and_safety": IconConfig(Icons.health_and_safety, Color(0xff26be0b)),
    "local_shipping": IconConfig(Icons.local_shipping, Color(0xff1058e7)),
    "pregnant_woman": IconConfig(Icons.pregnant_woman, Color(0xffff2a95)),
    "grid_view": IconConfig(Icons.grid_view, Color(0xff275aba)),
    "shield": IconConfig(Icons.shield, Color(0xff1058e7)),
    "home": IconConfig(Icons.home, Color(0xfff15f0b)),
    "gaval": IconConfig(Icons.gavel, Color(0xff15a3da)),
  };
}

class IconConfig {
  IconData icon;
  Color color;
  IconConfig(this.icon, this.color);
}

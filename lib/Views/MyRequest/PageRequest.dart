import 'package:Aidora/Views/MyRequest/Rejected.dart';
import 'package:Aidora/Views/MyRequest/approved.dart';
import 'package:Aidora/services/api_constants.dart';
import 'package:Aidora/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:Aidora/Controlers/homecontroller.dart';

class Pagerequest extends StatefulWidget {
  const Pagerequest({super.key});
  @override
  State<StatefulWidget> createState() => _Pagerequest();
}

class _Pagerequest extends State<Pagerequest> {
  @override
  void initState() {
    super.initState();
    _checkUserRequest();
  }

  Future<void> _checkUserRequest() async {
    var res = await ApiService.instance.get(
      ApiConstants.volunteerStateRequest,
      requiresAuth: true,
    );

    // -------------- State --------------
    if (res.data['profile_completed'] == false &&
        res.data['application_status'] == 'approved') {
      Get.offAll(() => (Approved()));
    }
    if (res.data['profile_completed'] == false &&
        res.data['application_status'] == 'rejected') {
      Get.offAll(() => (Rejected()));
    }
  }

  final FormController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Color(0xffF4F4F4),
        body: Column(
          children: [
            _headerImage(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: _formCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerImage() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Image.asset(
        "images/Waiting-pana (1) 1.png",
        height: 300,
        width: 400,
      ),
    );
  }
}

Widget _formCard() {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 150,
          color: Color(0x00E5E7EB),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, size: 10, color: Color(0xff7ad081)),
                SizedBox(width: 10),
                Text(
                  "Processing",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff7ad081),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          "Your request has been submitted",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 10),
        Text(
          "We are currently reviewing your application details. You will be notified immediately once a decision has been made.",
          textAlign: TextAlign.center,

          style: TextStyle(fontSize: 20, color: Colors.blueGrey),
        ),

        SizedBox(height: 30),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xff7AD081),
            borderRadius: BorderRadius.circular(30),
          ),
          child: MaterialButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home, size: 50, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Back to Home",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        TextButton(
          onPressed: () {},
          child: Text("View Request Details", style: TextStyle(fontSize: 16)),
        ),
      ],
    ),
  );
}

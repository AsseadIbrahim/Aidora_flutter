import 'package:first_flutter/Models/MyRequest/PinputExample.dart';
import 'package:first_flutter/Models/MyRequest/Rejected.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:first_flutter/Controlers/homecontroller.dart';

// ignore: must_be_immutable
class Approved extends StatelessWidget {
  Approved({super.key});

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
                child: _formCard(context),
              ),
            ),
            _logOut(),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _headerImage() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Image.asset(
        "images/Good team-cuate 1.png",
        height: 300,
        width: 400,
      ),
    );
  }

  Widget _logOut() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: Color(0xff7AD081),
          borderRadius: BorderRadius.circular(30),
        ),
        child: MaterialButton(
          onPressed: () {
            Get.to(() => Rejected());
          },
          child: Text(
            "Verify & Continue",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _formCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Your request has been approved, Enter the PIN code.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 20),
          // هون حطيت ال text field
          FractionallySizedBox(
            widthFactor: 1,
            // You can also checkout the [PinputBuilderExample]
            child: PinputExample(),
          ),

          SizedBox(height: 30),
          TextButton(
            onPressed: () {},
            child: Text(
              "Resend code ?",
              style: TextStyle(
                color: Color(0xff2d6a4f),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:first_flutter/Views/The_Form/Pageone.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:first_flutter/Controlers/homecontroller.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});
  @override
  State<StatefulWidget> createState() => _Welcome();
}

class _Welcome extends State<StatefulWidget> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 6), () {
      Get.off(() => Pageone());
    });
  }

  final FormController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Color(0xffF4F4F4),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _headerImage(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: _formCard(context),
              ),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _headerImage() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Image.asset("images/Team work-bro 1.png", height: 300, width: 400),
    );
  }

  Widget _formCard(BuildContext context) {
    return Text(
      "Thank you for your interest in\n helping, your information\n enables us to guide you to the \nright role",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25,
        color: const Color.fromARGB(255, 12, 97, 15),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

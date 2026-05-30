import 'package:Aidora/Views/The_Form/Pageone.dart';
import 'package:Aidora/services/api_constants.dart';
import 'package:Aidora/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:Aidora/Controlers/homecontroller.dart';
import 'package:Aidora/Views/MyRequest/PageRequest.dart';

class Pagefive extends StatefulWidget {
  const Pagefive({super.key});
  @override
  State<StatefulWidget> createState() => _Pagefive();
}

class _Pagefive extends State<Pagefive> {
  final FormController controller = Get.find();

  List categoriesTrue = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Color(0xffF4F4F4),
        body: Column(
          children: [
            _header(),
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

  /// ================= HEADER =================
  Widget _header() {
    return Container(
      height: 300,
      width: double.infinity,

      padding: EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: BoxDecoration(
        color: Color(0xff7AD081),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white24,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 90),
            ],
          ),
          SizedBox(height: 30),
          Text(
            "Almost there!",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 50),
          Text(
            "Help us understand your impact",
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 5),
          Text(
            "Step 5 of 5: Identity & Residence",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // ================= FORM =================
  Widget _formCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //PhoneNumberEmergency
          _section(
            title: "Emergency Contact",
            child: _textField_1(
              controller: controller.phoneNumberEmergency,
              hint: "+1(555) 000-0000",
              icon: Icons.perm_phone_msg_rounded,
              texthint: Text(
                "phone Number",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ),
          // 🔹 Volunteer
          _section(
            title: "Why do you want to volunteer?",
            child: _textField_2(
              controller: controller.volunteer,
              hint: "",
              texthint: Text(
                "Share your motivation and goais with us.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(height: 10),
          _buildAgreementsSection(controller),
          SizedBox(height: 10),

          Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              color: Color(0xff7AD081),
              borderRadius: BorderRadius.circular(30),
            ),

            child: MaterialButton(
              onPressed: () async {
                controller.isLoading.value = true;
                await ApiService.instance.post(
                  '${ApiConstants.volunteerPageFive}${controller.idOrganization}/volunteer/applications/',
                  requiresAuth: true,
                  body: {
                    "phone_number": controller.phoneNumberEmergency.text,
                    "why_volunteer": controller.volunteer.text,
                    "i_commit": controller.isPolicyCommitted.value,
                    "i_agree_terms": controller.isInfoAgreed.value,
                    "selected_services": categoriesTrue,
                  },
                );
                controller.isLoading.value = false;

                var res = await ApiService.instance.get(
                  ApiConstants.volunteerStateRequest,
                  requiresAuth: true,
                );
                if (res.data['profile_completed'] == false &&
                    res.data['application_status'] == null) {
                  Get.offAll(() => Pageone());
                } else {
                  Get.offAll(() => Pagerequest());
                }
              },
              child: controller.isLoading.value
                  ? CircularProgressIndicator()
                  : Text(
                      "Submit",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Section (Reusable)
  Widget _section({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  // 🔹 TextField and icon
  Widget _textField_1({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Text texthint,
  }) {
    return Column(
      children: [
        texthint,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xffF7F7F7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xff7AD081)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 🔹 TextField and without icon
  Widget _textField_2({
    required TextEditingController controller,
    required String hint,
    required Text texthint,
  }) {
    return Column(
      children: [
        texthint,

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xffF7F7F7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // قسم الموافقات
  Widget _buildAgreementsSection(FormController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // الموافقة على استخدام المعلومات
          Obx(
            () => CheckboxListTile(
              value: controller.isInfoAgreed.value,
              onChanged: controller.toggleInfoAgreement,
              title: const Text(
                'I agree that my information may be used for volunteer coordination purposes only.',
                style: TextStyle(fontSize: 14),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: EdgeInsets.zero,
              activeColor: Get.theme.primaryColor,
            ),
          ),

          const Divider(height: 8),

          // الموافقة على سياسة حماية الطفل
          Obx(
            () => CheckboxListTile(
              value: controller.isPolicyCommitted.value,
              onChanged: controller.togglePolicyCommitment,
              title: const Text(
                'I commit to the Child Safeguarding Policy and will uphold its standards.',
                style: TextStyle(fontSize: 14),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: EdgeInsets.zero,
              activeColor: Get.theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

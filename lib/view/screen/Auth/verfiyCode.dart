import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

import 'package:studentsystem/controller/Auth/verfiyCode_controller.dart';
import 'package:studentsystem/core/class/handlingdata.dart';
import 'package:studentsystem/core/constens/AppColar.dart';

class Verfiycode extends StatelessWidget {
  const Verfiycode({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VerfiycodeController());
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color.fromARGB(18, 37, 100, 235),
          ),

          GetBuilder<VerfiycodeController>(
            builder: (controller) => HandlingdataRequest(
              statusRequeste: controller.statusRequeste,
              widget: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColar.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColar.primaryAPP,
                        ),
                        child: const Icon(
                          Icons.verified_user_outlined,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "كود التحقق",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "يرجا ادخال كود تحقق المرسل الى بريدك ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColar.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 30),

                      OtpTextField(
                        fieldHeight: 50.0,
                        borderRadius: BorderRadius.circular(20),
                        numberOfFields: 5,
                        borderColor: Color(0xFF512DA8),
                        showFieldAsBox: true,
                        onCodeChanged: (String code) {},
                        onSubmit: (String verificationCode) {
                          controller.verfiycod(verificationCode);
                        },
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: controller.isTimerActive
                            ? null
                            : () {
                                controller.updateverfiycode();
                              },
                        child: Text(
                          controller.isTimerActive
                              ? "إعادة الإرسال خلال ${controller.seconds} ثانية"
                              : "إعادة ارسال كود التحقق",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

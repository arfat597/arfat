import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsystem/controller/Auth/forgetpassword_controller.dart';
import 'package:studentsystem/core/class/handlingdata.dart';
import 'package:studentsystem/core/constens/AppColar.dart';
import 'package:studentsystem/core/function/validTextForm.dart';
import 'package:studentsystem/view/widget/Auth/Costomtextformauth.dart';
import 'package:studentsystem/view/widget/Auth/MaterialButton.dart';

class Forgetpassword extends StatelessWidget {
  const Forgetpassword({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ForgetpasswordController());
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color.fromARGB(18, 37, 100, 235),
          ),

          GetBuilder<ForgetpasswordController>(
            builder: (controller) => HandlingdataRequest(
              statusRequeste: controller.statusRequeste,
              widget: Form(
                key: controller.formState,
                child: Center(
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
                            Icons.lock,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "استعادة كلمة المرور",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "سيتم ارسال كود تحقق الى بريد الطالب",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColar.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 30),
                        Costomtextformauth(
                          textlabel: "ادخل الرقم الجامعي",
                          texthint: "ادخل الرقم الجامعي",
                          icondata: Icons.person,
                          mycontroller: controller.number,
                          validator: (val) {
                            return validInpot(val!, 7, 30, "phone");
                          },
                        ),
                        const SizedBox(height: 20),
                        Materialbutton(
                          icondata: Icons.maps_ugc_outlined,
                          text: "تحقق",
                          onPressed: () {
                            controller.checknum();
                          },
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("العودة إلى تسجيل الدخول"),
                        ),
                      ],
                    ),
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

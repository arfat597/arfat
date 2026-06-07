import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:studentsystem/controller/Auth/login_controller.dart';
import 'package:studentsystem/core/class/handlingdata.dart';
import 'package:studentsystem/core/constens/AppColar.dart';
import 'package:studentsystem/core/constens/Appimage.dart';
import 'package:studentsystem/core/function/validTextForm.dart';
import 'package:studentsystem/view/widget/Auth/Costomtextformauth.dart';
import 'package:studentsystem/view/widget/Auth/MaterialButton.dart';
import 'package:studentsystem/view/widget/Auth/forget_pass_login.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(18, 37, 100, 235),
              ),
            ),
          ),

          GetBuilder<LoginController>(
            builder: (controller) => HandlingdataRequest(
              statusRequeste: controller.statusRequeste,
              widget: Form(
                key: controller.formState,
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 15),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(Appimage.ust),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // العنوان
                          const Text(
                            "نظام إدارة مشاريع \nالتخرج",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Cairo",
                            ),
                          ),
                          const SizedBox(height: 5),

                          // وصف تسجيل الدخول
                          Text(
                            "تسجيل الدخول الى حسابك",
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColar.grey,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Cairo",
                            ),
                          ),
                          const SizedBox(height: 30),
                          Costomtextformauth(
                            textlabel: " الرقم الجامعي",
                            texthint: "ادخل الرقم الجامعي",
                            icondata: Icons.person,
                            mycontroller: controller.number,
                            validator: (val) {
                              return validInpot(val!, 7, 30, "phone");
                            },
                          ),
                          const SizedBox(height: 25),

                          // حقل كلمة المرور
                          Costomtextformauth(
                            textlabel: " كلمة المرور",
                            texthint: "ادخل كلمة المرور",
                            icondata: Icons.lock,
                            mycontroller: controller.password,
                            validator: (val) {
                              return validInpot(val!, 5, 30, "password");
                            },
                          ),

                          // نسيت كلمة المرور
                          ForgetPassLogin(
                            text: "هل نسيت كلمة المرور ؟",
                            onTap: () {
                              controller.gotowpage();
                            },
                          ),

                          // زر تسجيل الدخول
                          Materialbutton(
                            icondata: Icons.lock,
                            text: "تسجيل الدخول",
                            onPressed: () {
                              controller.login();
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "للحصول على المساعدة : يرجى التواصل مع الدعم الفني",
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: "Cairo",
                              fontWeight: FontWeight.bold,
                              color: AppColar.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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

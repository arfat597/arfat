import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:studentsystem/controller/Auth/resetPassword_controller.dart';
import 'package:studentsystem/core/class/handlingdata.dart';
import 'package:studentsystem/core/constens/AppColar.dart';
import 'package:studentsystem/core/function/validTextForm.dart';
import 'package:studentsystem/view/widget/Auth/Costomtextformauth.dart';
import 'package:studentsystem/view/widget/Auth/MaterialButton.dart';

class Resetpassword extends StatelessWidget {
  const Resetpassword({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ResetpasswordController());
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color.fromARGB(18, 37, 100, 235),
          ),

          GetBuilder<ResetpasswordController>(
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
                            Icons.lock_reset_outlined,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "تغير كلمة المرور",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "يرجا كتابة كلمة مرور قوية",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColar.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 30),

                        Costomtextformauth(
                          textlabel: "كلمة المرور",
                          texthint: "ادخل كلمة المرور الجديدة",
                          icondata: Icons.lock,
                          mycontroller: controller.number,
                          validator: (val) {
                            return validInpot(val!, 7, 30, "password");
                          },
                        ),
                        const SizedBox(height: 20),

                        Costomtextformauth(
                          textlabel: "كلمة المرور",
                          texthint: "اعد ادخال كلمة المرور",
                          icondata: Icons.lock,
                          mycontroller: controller.newnumber,
                          validator: (val) {
                            return validInpot(val!, 7, 30, "password");
                          },
                        ),

                        const SizedBox(height: 20),

                        Materialbutton(
                          icondata: Icons.lock_open_outlined,
                          text: "تغير",
                          onPressed: () {
                            controller.resetpasswor();
                          },
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

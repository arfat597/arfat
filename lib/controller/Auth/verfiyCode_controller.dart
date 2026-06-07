import 'dart:async';
import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsystem/core/class/SupabaseCrud.dart';
import 'package:studentsystem/core/class/statusRequest.dart';
import 'package:studentsystem/core/constens/Approutes.dart';
import 'package:studentsystem/core/function/showrDialog.dart';

class VerfiycodeController extends GetxController {
  String? idstudent;
  statusRequest statusRequeste = statusRequest.none;
  SupabaseCrud supabaseCrud = SupabaseCrud();
  int seconds = 60;
  bool isTimerActive = false;
  Timer? timer;
  int? verfiyCode;

  verfiycod(String Code) async {
    statusRequeste = statusRequest.loding;
    update();
    final response = await supabaseCrud.selectWhere(
      table: "student",
      match: {"stud_id": idstudent, "stud_verfi_code": Code},
    );
    if (response.status == statusRequest.success) {
      if (response.data != null && response.data!.isNotEmpty) {
        statusRequeste = statusRequest.success;
        update();
        Get.toNamed(Approutes.resetPassword,arguments: {
          "stuid": idstudent
        });
      } else {
        statusRequeste = statusRequest.faliure;
        update();
        showLoginrDialog(
          false,
          Icons.info_outline,
          "خطأ",
          "رقم التحقق الذي ادخلتة غير صحيح",
          false,
          () {},
          () {
            Get.back();
          },
        );
      }
    } else {
      statusRequeste = statusRequest.faliure;
      update();
    }
  }

  updateverfiycode() async {
    generateFiveDigitCode();
    statusRequeste = statusRequest.loding;
    update();
    final response = await supabaseCrud.update(
      table: "student",
      match: {"stud_id": idstudent},
      newData: {"stud_verfi_code": verfiyCode},
    );
    if (response.status == statusRequest.success) {
      if (response.data != null) {
        statusRequeste = statusRequest.success;
        startTimer();
        update();
      }
    } else {
      print(response.error);
    }
    update();
  }

  generateFiveDigitCode() {
    final random = Random();
    verfiyCode = 10000 + random.nextInt(90000);
    return verfiyCode.toString();
  }

  void startTimer() {
    if (isTimerActive) return;

    isTimerActive = true;
    seconds = 60;
    update();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
        update();
      } else {
        timer.cancel();
        isTimerActive = false;
        update();
      }
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    idstudent = Get.arguments["stud"];
    print("77777777777777777777$idstudent");
    super.onInit();
  }
}

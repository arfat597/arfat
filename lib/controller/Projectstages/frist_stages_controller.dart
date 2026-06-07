import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsystem/core/class/SupabaseCrud.dart';
import 'package:studentsystem/core/class/statusRequest.dart';
import 'package:studentsystem/core/servieces/servieces.dart';

class FristStagesController extends GetxController {
  Myservieces myservieces = Get.find();
  String? username;
  statusRequest statusRequeste = statusRequest.none;
  SupabaseCrud supabaseCrud = SupabaseCrud();
  bool? grop;
  Map<String, dynamic> data = {};
  List<dynamic> data1 = [];
  List<dynamic> supervi = [];
  List<dynamic> info = [];
  int? selectedSupervisorId;
  int? selectedGroupId;
  late TextEditingController groupNameController;
  late TextEditingController researchDescriptionController;
  late TextEditingController researchTitleController;
  late TextEditingController researchTitleinfo;
  late TextEditingController researchDescrinfo;

  addgrop() async {
    statusRequeste = statusRequest.loding;
    update();
    final response = await supabaseCrud.selectOne(
      table: "student_group_view",
      match: {"stud_id": myservieces.sharedPref.getString("id")},
    );
    if (response.status == statusRequest.success) {
      if (response.data != null && response.data!.isNotEmpty) {
        if (response.data!["group_id"] != null && response.data!.isNotEmpty) {
          statusRequeste = statusRequest.success;
          grop = true;
        } else {
          statusRequeste = statusRequest.success;
          grop = false;

          data = response.data!;
          ingrop();
        }
      }
    } else {
      print(response.error);
    }
    update();
  }

  ingrop() async {
    statusRequeste = statusRequest.loding;
    update();
    final response = await supabaseCrud.selectWhere(
      table: "student_group_view",
      match: {"acye_year": data["acye_year"], "id_program": data["id_program"]},
      notNullColumns: ["group_id"],
      lessThan: {"num_grops": 10},
    );
    if (response.status == statusRequest.success) {
      if (response.data != null && response.data!.isNotEmpty) {
        data1 = List<Map<String, dynamic>>.from(response.data!);
        print(data1);
        statusRequeste = statusRequest.success;
      } else {
        statusRequeste = statusRequest.success;
      }
    } else {}
    update();
  }

  supervisor() async {
    statusRequeste = statusRequest.loding;
    update();
    final response = await supabaseCrud.selectWhere(
      table: "supervisor",
      match: {"program_id": myservieces.sharedPref.getString("program")},
    );

    if (response.status == statusRequest.success) {
      if (response.data != null && response.data!.isNotEmpty) {
        supervi = List<Map<String, dynamic>>.from(response.data!);
        statusRequeste = statusRequest.success;
      }
    } else {
      print(response.error);
    }
    update();
  }

  newgrop() async {
    // التحقق من الحقول قبل التنفيذ
    if (groupNameController.text.trim().isEmpty ||
        researchTitleController.text.trim().isEmpty ||
        researchDescriptionController.text.trim().isEmpty ||
        selectedSupervisorId == null) {
      Get.snackbar(
        "خطأ",
        "الرجاء إدخال جميع البيانات المطلوبة",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
        icon: const Icon(Icons.error, color: Colors.red),
      );
      return;
    }

    if (grop == false) {
      statusRequeste = statusRequest.loding;
      update();
      final response = await supabaseCrud.insert(
        table: "groups",
        data: {
          "group_name": groupNameController.text.trim(),
          "id_sprvsr": selectedSupervisorId,
          "id_group_state": 1,
          "group_led_id": myservieces.sharedPref.getString("id"),
          "id_acye": data["id_academy_year"],
          "id_program": myservieces.sharedPref.getString("program"),
          "group_isactive": true,
          "group_progress": 0.14,
          "current_stage": 1,
          "num_grops": 1,
          "created_at": DateTime.now().toIso8601String(),
        },
      );

      if (response.status == statusRequest.success) {
        if (response.data != null) {
          int newGroupId = response.data!["group_id"];

          final response2 = await supabaseCrud.insert(
            table: "first stage",
            data: {
              "group_id": newGroupId,
              "research_title": researchTitleController.text.trim(),
              "research_description": researchDescriptionController.text.trim(),
            },
          );

          if (response2.status == statusRequest.success) {
            if (response2.data != null) {
              final response3 = await supabaseCrud.update(
                table: "student",
                match: {"stud_id": myservieces.sharedPref.getString("id")},
                newData: {"id_group": newGroupId},
              );
              if (response3.status == statusRequest.success) {
                if (response3.data != null) {
                  grop = true;
                  infogrop();
                  statusRequeste = statusRequest.success;
                  Get.snackbar(
                    "تم الإنشاء ✅",
                    "تم إنشاء الفريق والبحث بنجاح  \n والفكرة قيد المراجعة سيتم الرد على الموافقة فيما بعد",
                    backgroundColor: Colors.green.shade50,
                    colorText: Colors.black87,
                    icon: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 28,
                    ),
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(12),
                    borderRadius: 12,
                    duration: const Duration(seconds: 4),
                  );
                }
              }
            }
          }
        }
      } else {
        Get.snackbar(
          "خطأ",
          "فشل في إنشاء الفريق: ${response.error}",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black,
          icon: const Icon(Icons.error, color: Colors.red),
        );
      }
    } else {
      Get.snackbar(
        "خطأ",
        "انت موجود ظمن فريق في الوقت الحالي",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
        icon: const Icon(Icons.error, color: Colors.red),
      );
    }
    update();
  }

  selectgrop() async {
    statusRequeste = statusRequest.loding;
    update();
    final response = await supabaseCrud.update(
      table: "student",
      match: {"stud_id": myservieces.sharedPref.getString("id")},
      newData: {"id_group": selectedGroupId},
    );
    if (response.status == statusRequest.success) {
      if (response.data != null) {
        grop = true;
        infogrop();
        statusRequeste = statusRequest.success;
        Get.snackbar(
          "تم الاختيار ✅",
          "تم الانضمام الى الفريق الذي اخترتة",
          backgroundColor: Colors.green.shade50,
          colorText: Colors.black87,
          icon: const Icon(Icons.check_circle, color: Colors.green),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          duration: const Duration(seconds: 4),
        );
      }
    }
    update();
  }

  infogrop() async {
    statusRequeste = statusRequest.loding;
    update();
    final response = await supabaseCrud.selectWhere(
      table: "first_stage_view",
      match: {"group_id": myservieces.sharedPref.getString("idgroup")},
    );

    if (response.status == statusRequest.success) {
      if (response.data != null && response.data!.isNotEmpty) {
        info = List<Map<String, dynamic>>.from(response.data!);
        statusRequeste = statusRequest.success;
      } else {
        statusRequeste = statusRequest.success;
      }
    } else {
      statusRequeste = statusRequest.serverExecption;
    }

    update();
  }

  updatinfo() async {
    if (info[0]["leader_id"].toString() ==
        myservieces.sharedPref.getString("id")) {
      statusRequeste = statusRequest.loding;
      update();

      final response = await supabaseCrud.update(
        table: "first stage",
        match: {"group_id": myservieces.sharedPref.getString("idgroup")},
        newData: {
          "research_title": researchTitleinfo.text.trim(),
          "research_description": researchDescrinfo.text.trim(),
        },
      );
      if (response.status == statusRequest.success) {
        info.clear;
        infogrop();
        statusRequeste = statusRequest.success;
        Get.snackbar(
          "تم التعديل ✅",
          "تم تعديل بيانات البحث بنجاح",
          backgroundColor: Colors.green.shade50,
          colorText: Colors.black87,
          icon: const Icon(Icons.check_circle, color: Colors.green),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
        );
      } else {
        statusRequeste = statusRequest.success;
        Get.snackbar(
          "خطأ",
          "فشل في تعديل بيانات البحث: ${response.error}",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black,
          icon: const Icon(Icons.error, color: Colors.red),
        );
      }
    } else {
      Get.snackbar(
        "غير مسموح",
        "لا يمكنك تعديل البيانات لأنك لست القائد",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
        icon: const Icon(Icons.error, color: Colors.red),
      );
    }
    update();
  }

  String approvalText(dynamic value) {
    if (value == null) return "⏳ قيد المراجعة";
    if (value == true) return "✔️ موافق";
    return "❌ غير موافق";
  }

  @override
  void onInit() {
    researchTitleController = TextEditingController();
    researchDescriptionController = TextEditingController();
    groupNameController = TextEditingController();
    researchTitleinfo = TextEditingController();
    researchDescrinfo = TextEditingController();

    addgrop();
    supervisor();

    infogrop();

    super.onInit();
  }
}

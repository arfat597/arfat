import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:studentsystem/core/class/SupabaseCrud.dart';
import 'package:studentsystem/core/class/statusRequest.dart';
import 'package:studentsystem/core/servieces/servieces.dart';

class SecondStageController extends GetxController {
  final Myservieces myservieces = Get.find();
  final SupabaseCrud supabaseCrud = SupabaseCrud();
  final SupabaseClient client = Supabase.instance.client;

  statusRequest statusRequeste = statusRequest.none;

  // ملف PDF
  File? pickedPdfFile;
  String? pickedPdfName;

  // ملاحظات الطالب (اختياري)
  TextEditingController notesController = TextEditingController();

  // سجل الاعتماد الحالي (إذا موجود)
  Map<String, dynamic>? stageRecord;
  List<Map<String, dynamic>> titles = [];

  // ============ UI Helpers للمطابقة مع المرحلة الرابعة ============
  bool get isApproved => stageRecord?['stage_approval'] == true;
  bool get isPending =>
      stageRecord != null && stageRecord!['stage_approval'] == false;

  String get approvalStatus {
    if (stageRecord == null) return "لم يتم الإرسال بعد";
    if (stageRecord!['stage_approval'] == true) return "تم الاعتماد";
    return "قيد التنفيذ";
  }

  String get approvalSubtext {
    if (stageRecord == null) return "قم بإرفاق ملف الخطة وإرساله للاعتماد";
    if (stageRecord!['stage_approval'] == true) return "تمت الموافقة على الخطة";
    return "يرجى انتظار مراجعة المشرف";
  }

  double get completionPercentage {
    if (stageRecord == null) return 0.0;
    double progress = 0.0;
    if (stageRecord!['pdf_file'] != null &&
        stageRecord!['pdf_file'].toString().isNotEmpty)
      progress += 0.35;
    if (stageRecord!['stage_approval'] == true) progress += 0.65;
    return progress;
  }

  List<Map<String, dynamic>> get notesList {
    if (stageRecord == null) return [];
    List<Map<String, dynamic>> res = [];
    if (stageRecord!['sprvsr_note'] != null &&
        stageRecord!['sprvsr_note'].toString().isNotEmpty) {
      res.add({"sender": "المشرف", "text": stageRecord!['sprvsr_note']});
    }
    return res;
  }
  // ================================================================

  Future<void> fetchTitles() async {
    statusRequeste = statusRequest.loding;
    update();

    final response = await supabaseCrud.selectAll(
      table: "Title of second stage",
    );

    if (response.status == statusRequest.success && response.data != null) {
      titles = List<Map<String, dynamic>>.from(response.data!);
      statusRequeste = statusRequest.success;
    } else {
      statusRequeste = statusRequest.serverExecption;
    }

    update();
  }

  // ------------------ جلب السجل الحالي ------------------
  Future<void> fetchStageRecord() async {
    final groupId = myservieces.sharedPref.getString("idgroup");
    if (groupId == null) return;

    statusRequeste = statusRequest.loding;
    update();

    final response = await supabaseCrud.selectWhere(
      table: "stage2_titles_approval",
      match: {"id_group": groupId},
    );

    if (response.status == statusRequest.success &&
        response.data != null &&
        response.data!.isNotEmpty) {
      stageRecord = Map<String, dynamic>.from(response.data![0]);
      statusRequeste = statusRequest.success;
    } else {
      stageRecord = null;
      statusRequeste = statusRequest.success;
    }
    update();
  }

  // ------------------ اختيار ملف PDF ------------------
  Future<void> pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      pickedPdfFile = File(result.files.single.path!);
      pickedPdfName = result.files.single.name;
      update();
    }
  }

  // ------------------ حذف الملف القديم ------------------
  Future<void> deleteOldFileIfExists() async {
    if (stageRecord != null && stageRecord!['pdf_file'] != null) {
      final oldUrl = stageRecord!['pdf_file'] as String;
      final oldFileName = oldUrl.split('/').last;

      try {
        await client.storage.from('stage2').remove([oldFileName]);
        print("تم حذف الملف القديم: $oldFileName");
      } catch (e) {
        print("فشل حذف الملف القديم: $e");
      }
    }
  }

  // ------------------ رفع الملف إلى البكت stage2 ------------------
  Future<String?> uploadPdfToStorage() async {
    if (pickedPdfFile == null) return null;
    final groupId = myservieces.sharedPref.getString("idgroup") ?? "unknown";
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filename = "group_${groupId}_stage2_$timestamp.pdf";

    try {
      final fileBytes = await pickedPdfFile!.readAsBytes();

      await client.storage
          .from('stage2')
          .uploadBinary(
            filename,
            fileBytes,
            fileOptions: const FileOptions(contentType: 'application/pdf'),
          );

      final publicUrl = client.storage.from('stage2').getPublicUrl(filename);
      return publicUrl;
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "فشل رفع الملف: $e",
        backgroundColor: Colors.red.shade100,
      );
      return null;
    }
  }

  // ------------------ إرسال للاعتماد ------------------
  Future<void> submitStage2Approval() async {
    if (pickedPdfFile == null) {
      Get.snackbar(
        "خطأ",
        "الرجاء رفع ملف الخطة بصيغة PDF",
        backgroundColor: Colors.red.shade100,
      );
      return;
    }

    statusRequeste = statusRequest.loding;
    update();

    try {
      final groupIdStr = myservieces.sharedPref.getString("idgroup");
      final studentIdStr = myservieces.sharedPref.getString("id");

      if (groupIdStr == null || studentIdStr == null) {
        Get.snackbar(
          "خطأ",
          "بيانات المستخدم أو الفريق غير متوفرة",
          backgroundColor: Colors.red.shade100,
        );
        statusRequeste = statusRequest.serverExecption;
        update();
        return;
      }

      final groupId = int.tryParse(groupIdStr);
      final studentId = int.tryParse(studentIdStr);

      if (groupId == null || studentId == null) {
        Get.snackbar(
          "خطأ",
          "معرف الفريق أو الطالب غير صالح",
          backgroundColor: Colors.red.shade100,
        );
        statusRequeste = statusRequest.serverExecption;
        update();
        return;
      }

      final groupRes = await supabaseCrud.selectOne(
        table: "groups",
        match: {"group_id": groupId},
      );

      if (groupRes.status != statusRequest.success ||
          groupRes.data == null ||
          groupRes.data!.isEmpty) {
        Get.snackbar(
          "خطأ",
          "تعذر جلب بيانات الفريق",
          backgroundColor: Colors.red.shade100,
        );
        statusRequeste = statusRequest.serverExecption;
        update();
        return;
      }

      final leaderId = groupRes.data?["group_led_id"] as int?;
      if (leaderId == null) {
        Get.snackbar(
          "خطأ",
          "بيانات الفريق غير مكتملة",
          backgroundColor: Colors.red.shade100,
        );
        statusRequeste = statusRequest.serverExecption;
        update();
        return;
      }

      if (leaderId != studentId) {
        Get.snackbar(
          "ممنوع",
          "فقط قائد الفريق يمكنه رفع الملف",
          backgroundColor: Colors.orange.shade100,
          icon: const Icon(Icons.warning, color: Colors.orange),
        );
        statusRequeste = statusRequest.serverExecption;
        update();
        return;
      }

      // حذف الملف القديم أولاً
      await deleteOldFileIfExists();

      // رفع الملف الجديد
      final pdfUrl = await uploadPdfToStorage();
      if (pdfUrl == null) {
        statusRequeste = statusRequest.serverExecption;
        update();
        return;
      }

      final payload = {
        "id_group": groupId,
        "pdf_file": pdfUrl,
        "stage_approval": false,
        "student_notes": notesController.text.trim(),
      };

      if (stageRecord != null) {
        final res = await supabaseCrud.update(
          table: "stage2_titles_approval",
          match: {"id_group": groupId},
          newData: payload,
        );
        if (res.status == statusRequest.success) {
          Get.snackbar(
            "تم",
            "تم تحديث الخطة وإرسالها للاعتماد",
            backgroundColor: Colors.green.shade50,
          );
        } else {
          throw res.error ?? "فشل التحديث";
        }
      } else {
        final res = await supabaseCrud.insert(
          table: "stage2_titles_approval",
          data: payload,
        );
        if (res.status == statusRequest.success) {
          Get.snackbar(
            "تم",
            "تم إرسال الخطة للاعتماد بنجاح",
            backgroundColor: Colors.green.shade50,
          );
        } else {
          throw res.error ?? "فشل الإدراج";
        }
      }

      stageRecord = payload;
      statusRequeste = statusRequest.success;
    } catch (e) {
      statusRequeste = statusRequest.serverExecption;
      Get.snackbar(
        "خطأ",
        "فشل الإرسال: $e",
        backgroundColor: Colors.red.shade100,
      );
      print(e);
    } finally {
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchTitles();
    fetchStageRecord();
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}

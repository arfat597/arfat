import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:studentsystem/core/class/SupabaseCrud.dart';
import 'package:studentsystem/core/class/statusRequest.dart';
import 'package:studentsystem/core/servieces/servieces.dart';

class FourthStageController extends GetxController {
  final Myservieces myservieces = Get.find();
  final SupabaseCrud supabaseCrud = SupabaseCrud();
  final SupabaseClient client = Supabase.instance.client;

  statusRequest statusRequeste = statusRequest.none;

  // ملف PDF
  File? pickedFile;
  String? pickedFileName;

  // سجل المرحلة الرابعة من جدول "fourth stage"
  Map<String, dynamic>? stageRecord;

  // نسبة الإنجاز (يتم حسابها بناءً على حالة الاعتماد والملف)
  double completionPercentage = 0.0;

  // حالة الاعتماد
  // null = قيد التنفيذ، false = مرفوض، true = معتمد
  String get approvalStatus {
    if (stageRecord == null) return "لم يتم الإرسال بعد";
    final approval = stageRecord!['approval'];
    if (approval == null) return "قيد التنفيذ";
    if (approval == true) return "تم الاعتماد";
    return "تم الرفض";
  }

  String get approvalSubtext {
    if (stageRecord == null) return "قم بإرفاق الملف وإرساله للاعتماد";
    final approval = stageRecord!['approval'];
    if (approval == null) return "يرجى انتظار المراجعة";
    if (approval == true) return "تمت الموافقة على المرحلة";
    return "تم رفض الملف، يرجى مراجعة الملاحظات وإعادة الرفع";
  }

  bool get isApproved => stageRecord?['approval'] == true;
  bool get isRejected => stageRecord?['approval'] == false;
  bool get isPending => stageRecord != null && stageRecord!['approval'] == null;

  // الملاحظات من الجدول
  List<Map<String, dynamic>> get notes {
    if (stageRecord == null) return [];
    List<Map<String, dynamic>> result = [];

    if (stageRecord!['sprvsr_notes'] != null &&
        stageRecord!['sprvsr_notes'].toString().isNotEmpty) {
      result.add({"sender": "المشرف", "text": stageRecord!['sprvsr_notes']});
    }

    if (stageRecord!['haed_notes'] != null &&
        stageRecord!['haed_notes'].toString().isNotEmpty) {
      result.add({"sender": "رئيس القسم", "text": stageRecord!['haed_notes']});
    }

    if (stageRecord!['dean_notes'] != null &&
        stageRecord!['dean_notes'].toString().isNotEmpty) {
      result.add({"sender": "العميد", "text": stageRecord!['dean_notes']});
    }

    return result;
  }

  // ============ حساب نسبة الإنجاز ============
  // null = قيد التنفيذ (35%)، false = مرفوض (35%)، true = معتمد (100%)
  void _calculateProgress() {
    if (stageRecord == null) {
      completionPercentage = 0.0;
      return;
    }

    double progress = 0.0;

    // تم رفع الملف = 35%
    if (stageRecord!['stage4_pdf'] != null &&
        stageRecord!['stage4_pdf'].toString().isNotEmpty) {
      progress += 0.35;
    }

    // تم الاعتماد = 65% إضافية (المجموع 100%)
    if (stageRecord!['approval'] == true) {
      progress += 0.65;
    }

    completionPercentage = progress;
  }

  // ============ جلب سجل المرحلة الرابعة ============
  Future<void> fetchStageRecord() async {
    final groupId = myservieces.sharedPref.getString("idgroup");
    if (groupId == null) return;

    statusRequeste = statusRequest.loding;
    update();

    final response = await supabaseCrud.selectWhere(
      table: "fourth stage",
      match: {"id_group": groupId},
    );

    if (response.status == statusRequest.success &&
        response.data != null &&
        response.data!.isNotEmpty) {
      stageRecord = Map<String, dynamic>.from(response.data![0]);
    } else {
      stageRecord = null;
    }

    _calculateProgress();
    statusRequeste = statusRequest.success;
    update();
  }

  // ============ اختيار ملف PDF فقط ============
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      // التحقق من أن الملف PDF فعلاً
      final fileName = result.files.single.name;
      if (!fileName.toLowerCase().endsWith('.pdf')) {
        Get.snackbar(
          "خطأ",
          "يجب أن يكون الملف بصيغة PDF فقط",
          backgroundColor: Colors.red.shade100,
        );
        return;
      }
      pickedFile = File(result.files.single.path!);
      pickedFileName = fileName;
      update();
    }
  }

  // ============ حذف الملف القديم ============
  Future<void> deleteOldFileIfExists() async {
    if (stageRecord != null && stageRecord!['stage4_pdf'] != null) {
      final oldUrl = stageRecord!['stage4_pdf'] as String;
      final oldFileName = oldUrl.split('/').last;
      try {
        await client.storage.from('stage4').remove([oldFileName]);
        print("تم حذف الملف القديم: $oldFileName");
      } catch (e) {
        print("فشل حذف الملف القديم: $e");
      }
    }
  }

  Future<String?> uploadFileToStorage() async {
    if (pickedFile == null) return null;
    final groupId = myservieces.sharedPref.getString("idgroup") ?? "unknown";
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filename = "group_${groupId}_stage4_$timestamp.pdf";

    try {
      final fileBytes = await pickedFile!.readAsBytes();
      await client.storage
          .from('stage4')
          .uploadBinary(
            filename,
            fileBytes,
            fileOptions: const FileOptions(contentType: 'application/pdf'),
          );

      final publicUrl = client.storage.from('stage4').getPublicUrl(filename);
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

  // ============ التحقق من قائد الفريق من الكاش ============
  bool _isGroupLeader() {
    final studentIdStr = myservieces.sharedPref.getString("id");
    final leaderIdStr = myservieces.sharedPref.getString("leaderid");

    if (studentIdStr == null || leaderIdStr == null) return false;
    return studentIdStr == leaderIdStr;
  }

  // ============ إرسال للاعتماد ============
  Future<void> submitStageApproval() async {
    if (pickedFile == null) {
      Get.snackbar(
        "خطأ",
        "الرجاء إرفاق ملف الدراسات الميدانية بصيغة PDF",
        backgroundColor: Colors.red.shade100,
      );
      return;
    }

    // التحقق من أن الطالب هو قائد الفريق من الكاش
    if (!_isGroupLeader()) {
      Get.snackbar(
        "ممنوع",
        "فقط قائد الفريق يمكنه رفع الملف",
        backgroundColor: Colors.orange.shade100,
        icon: const Icon(Icons.warning, color: Colors.orange),
      );
      return;
    }

    statusRequeste = statusRequest.loding;
    update();

    try {
      final groupIdStr = myservieces.sharedPref.getString("idgroup");

      if (groupIdStr == null) {
        Get.snackbar(
          "خطأ",
          "بيانات الفريق غير متوفرة",
          backgroundColor: Colors.red.shade100,
        );
        statusRequeste = statusRequest.serverExecption;
        update();
        return;
      }

      final groupId = int.tryParse(groupIdStr);

      if (groupId == null) {
        Get.snackbar(
          "خطأ",
          "معرف الفريق غير صالح",
          backgroundColor: Colors.red.shade100,
        );
        statusRequeste = statusRequest.serverExecption;
        update();
        return;
      }

      // حذف الملف القديم أولاً
      await deleteOldFileIfExists();

      // رفع الملف الجديد
      final pdfUrl = await uploadFileToStorage();
      if (pdfUrl == null) {
        statusRequeste = statusRequest.serverExecption;
        update();
        return;
      }

      // approval = null يعني قيد التنفيذ (في انتظار المراجعة)
      final payload = {"id_group": groupId, "stage4_pdf": pdfUrl};

      if (stageRecord != null) {
        // تحديث السجل الموجود
        final res = await supabaseCrud.update(
          table: "fourth stage",
          match: {"id_group": groupId},
          newData: payload,
        );
        if (res.status == statusRequest.success) {
          Get.snackbar(
            "تم",
            "تم تحديث ملف الدراسات الميدانية وإرساله للاعتماد",
            backgroundColor: Colors.green.shade50,
          );
        } else {
          throw res.error ?? "فشل التحديث";
        }
      } else {
        // إدراج سجل جديد
        final res = await supabaseCrud.insert(
          table: "fourth stage",
          data: payload,
        );
        if (res.status == statusRequest.success) {
          Get.snackbar(
            "تم",
            "تم إرسال ملف الدراسات الميدانية للاعتماد بنجاح",
            backgroundColor: Colors.green.shade50,
          );
        } else {
          throw res.error ?? "فشل الإدراج";
        }
      }

      // تنظيف وإعادة تحميل
      pickedFile = null;
      pickedFileName = null;
      await fetchStageRecord();
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
    fetchStageRecord();
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:studentsystem/core/class/SupabaseCrud.dart';
import 'package:studentsystem/core/class/statusRequest.dart';
import 'package:studentsystem/core/servieces/servieces.dart';

class SeventhStageController extends GetxController {
  final Myservieces myservieces = Get.find();
  final SupabaseCrud supabaseCrud = SupabaseCrud();
  final SupabaseClient client = Supabase.instance.client;

  statusRequest statusRequeste = statusRequest.none;

  // بيانات الجروب من جدول groups
  Map<String, dynamic> groupData = {};

  // ملف PDF المحدد
  File? pickedPdfFile;
  String? pickedPdfName;

  bool isSending = false;

  bool get isArchived =>
      groupData.isNotEmpty &&
      groupData['final_document'] != null &&
      groupData['archived'] == true;

  bool get isGroupLeader {
    final studentIdStr = myservieces.sharedPref.getString("id");
    final leaderIdStr = myservieces.sharedPref.getString("leaderid");

    if (studentIdStr == null || leaderIdStr == null) return false;
    return studentIdStr == leaderIdStr;
  }

  String get finalDocumentUrl => groupData['final_document']?.toString() ?? "";

  // جلب بيانات الجروب من جدول groups
  Future<void> fetchGroupData() async {
    final groupIdStr = myservieces.sharedPref.getString("idgroup");
    if (groupIdStr == null) {
      statusRequeste = statusRequest.serverExecption;
      update();
      return;
    }

    final groupId = int.tryParse(groupIdStr);
    if (groupId == null) {
      statusRequeste = statusRequest.serverExecption;
      update();
      return;
    }

    statusRequeste = statusRequest.loding;
    update();

    try {
      final response = await supabaseCrud.selectOne(
        table: "groups",
        match: {"group_id": groupId},
      );

      if (response.status == statusRequest.success && response.data != null) {
        groupData = Map<String, dynamic>.from(response.data!);
        statusRequeste = statusRequest.success;
      } else {
        groupData = {};
        statusRequeste = statusRequest.success;
      }
    } catch (e) {
      statusRequeste = statusRequest.serverExecption;
      debugPrint("Error fetching group data: $e");
    }
    update();
  }

  // اختيار ملف PDF
  Future<void> pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      final fileName = result.files.single.name;
      if (!fileName.toLowerCase().endsWith('.pdf')) {
        Get.snackbar(
          "تنبيه",
          "يجب أن يكون الملف بصيغة PDF فقط",
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.black87,
          icon: const Icon(Icons.warning, color: Colors.orange),
        );
        return;
      }
      pickedPdfFile = File(result.files.single.path!);
      pickedPdfName = fileName;
      update();
    }
  }

  // حذف الملف القديم في حالة رفعه سابقاً
  Future<void> deleteOldFileIfExists() async {
    if (groupData.isNotEmpty && groupData['final_document'] != null) {
      final oldUrl = groupData['final_document'] as String;
      final oldFileName = oldUrl.split('/').last;

      try {
        await client.storage.from('archived').remove([oldFileName]);
        debugPrint("Deleted old archived file: $oldFileName");
      } catch (e) {
        debugPrint("Failed to delete old archived file: $e");
      }
    }
  }

  // رفع الملف إلى الاستورج في باكت archived
  Future<String?> uploadPdfToStorage() async {
    if (pickedPdfFile == null) return null;
    final groupId = myservieces.sharedPref.getString("idgroup") ?? "unknown";
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filename = "group_${groupId}_final_$timestamp.pdf";

    try {
      final fileBytes = await pickedPdfFile!.readAsBytes();

      await client.storage
          .from('archived')
          .uploadBinary(
            filename,
            fileBytes,
            fileOptions: const FileOptions(contentType: 'application/pdf'),
          );

      final publicUrl = client.storage.from('archived').getPublicUrl(filename);
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

  // إرسال الملف وحفظه بالجدول
  Future<void> submitFinalDocument() async {
    if (pickedPdfFile == null) {
      Get.snackbar(
        "تنبيه",
        "الرجاء إرفاق ملف البحث النهائي أولاً بصيغة PDF",
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.black87,
        icon: const Icon(Icons.warning, color: Colors.orange),
      );
      return;
    }

    if (!isGroupLeader) {
      Get.snackbar(
        "ممنوع",
        "عذراً، لا يمكن إرفاق الملف إلا من قبل قائد المشروع",
        backgroundColor: Colors.orange.shade100,
        icon: const Icon(Icons.warning, color: Colors.orange),
      );
      return;
    }

    isSending = true;
    update();

    try {
      final groupIdStr = myservieces.sharedPref.getString("idgroup");
      if (groupIdStr == null) {
        Get.snackbar(
          "خطأ",
          "بيانات الفريق غير متوفرة",
          backgroundColor: Colors.red.shade100,
        );
        isSending = false;
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
        isSending = false;
        update();
        return;
      }

      // حذف القديم إن وجد
      await deleteOldFileIfExists();

      // رفع الجديد
      final pdfUrl = await uploadPdfToStorage();
      if (pdfUrl == null) {
        isSending = false;
        update();
        return;
      }

      // تحديث الجدول: final_document = pdfUrl, archived = true, group_progress = 1.0
      final res = await supabaseCrud.update(
        table: "groups",
        match: {"group_id": groupId},
        newData: {
          "final_document": pdfUrl,
          "archived": true,
          "group_progress": 1.0,
        },
      );

      if (res.status == statusRequest.success) {
        Get.snackbar(
          "تم بنجاح",
          "تم إرسال ملف البحث النهائي للاعتماد بنجاح",
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
          icon: const Icon(Icons.check_circle, color: Colors.green),
          duration: const Duration(seconds: 3),
        );

        // تفريغ الملف المختار
        pickedPdfFile = null;
        pickedPdfName = null;

        // إعادة جلب البيانات لتحديث الحالة
        await fetchGroupData();
      } else {
        throw res.error ?? "فشل تحديث بيانات المجموعة";
      }
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "فشل الإرسال: $e",
        backgroundColor: Colors.red.shade100,
      );
      debugPrint(e.toString());
    } finally {
      isSending = false;
      update();
    }
  }

  // اشتراك بقنوات ريال تايم للتحديث التلقائي
  Future<void> realtimeSubscription() async {
    final groupId = myservieces.sharedPref.getString("idgroup");
    if (groupId == null) return;

    supabaseCrud.subscribeToChanges(
      channelName: "group_channel_seventh",
      table: "groups",
      columnFilter: "group_id",
      valueFilter: int.parse(groupId),
      onChange: (payload) async {
        fetchGroupData();
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    fetchGroupData();
    realtimeSubscription();
  }
}

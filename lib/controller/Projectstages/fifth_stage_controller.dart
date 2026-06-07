import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:studentsystem/core/class/SupabaseCrud.dart';
import 'package:studentsystem/core/class/statusRequest.dart';
import 'package:studentsystem/core/servieces/servieces.dart';

class FifthStageController extends GetxController {
  final Myservieces myservieces = Get.find();
  final SupabaseCrud supabaseCrud = SupabaseCrud();
  final SupabaseClient client = Supabase.instance.client;

  statusRequest statusRequeste = statusRequest.none;

  List<Map<String, dynamic>> titles = [];

  Map<int, Map<String, dynamic>> stageRecords = {};

  Map<int, File?> pickedFiles = {};
  Map<int, String?> pickedFileNames = {};

  // ===================== الإحصائيات =====================

  int get totalChapters => titles.length;

  int get approvedCount {
    int count = 0;

    for (var record in stageRecords.values) {
      if (record['approval'] == true) {
        count++;
      }
    }

    return count;
  }

  int get rejectedCount {
    int count = 0;

    for (var record in stageRecords.values) {
      if (record['approval'] == false) {
        count++;
      }
    }

    return count;
  }

  int get pendingCount {
    int count = 0;

    for (var record in stageRecords.values) {
      if (record['approval'] == null && record['pdf_file'] != null) {
        count++;
      }
    }

    return count;
  }

  double get completionPercentage {
    if (totalChapters == 0) return 0.0;

    return approvedCount / totalChapters;
  }

  // ===================== بيانات الفصل =====================

  Map<String, dynamic>? getRecordForTitle(int titleId) {
    return stageRecords[titleId];
  }

  String getApprovalStatus(int titleId) {
    final record = stageRecords[titleId];

    if (record == null || record['pdf_file'] == null) {
      return "not_submitted";
    }

    final approval = record['approval'];

    if (approval == null) return "pending";

    if (approval == true) return "approved";

    return "rejected";
  }

  String? getSupervisorNote(int titleId) {
    final record = stageRecords[titleId];

    if (record == null) return null;

    final note = record['sprvsr_note'];

    if (note != null && note.toString().isNotEmpty) {
      return note.toString();
    }

    return null;
  }

  String? getPdfUrl(int titleId) {
    final record = stageRecords[titleId];

    if (record == null) return null;

    return record['pdf_file']?.toString();
  }

  // ===================== التحقق من قائد الفريق =====================

  bool _isGroupLeader() {
    final studentIdStr = myservieces.sharedPref.getString("id");

    final leaderIdStr = myservieces.sharedPref.getString("leaderid");

    if (studentIdStr == null || leaderIdStr == null) {
      return false;
    }

    return studentIdStr == leaderIdStr;
  }

  // ===================== جلب العناوين =====================

  Future<void> fetchTitles() async {
    final response = await supabaseCrud.selectAll(table: "fifth stage titles");

    if (response.status == statusRequest.success && response.data != null) {
      titles = List<Map<String, dynamic>>.from(response.data!);

      titles.sort(
        (a, b) => (a['title_id'] as int).compareTo(b['title_id'] as int),
      );
    }
  }

  // ===================== جلب السجلات =====================

  Future<void> fetchStageRecords() async {
    final groupId = myservieces.sharedPref.getString("idgroup");

    if (groupId == null) return;

    final response = await supabaseCrud.selectWhere(
      table: "fifth_Stage",
      match: {"group_id": groupId},
    );

    if (response.status == statusRequest.success && response.data != null) {
      stageRecords.clear();

      for (var record in response.data!) {
        final titleId = record['title_id'];

        if (titleId != null) {
          stageRecords[titleId as int] = Map<String, dynamic>.from(record);
        }
      }
    }
  }

  // ===================== تحميل البيانات =====================

  Future<void> _loadData() async {
    statusRequeste = statusRequest.loding;

    update();

    try {
      await fetchTitles();

      await fetchStageRecords();

      statusRequeste = statusRequest.success;
    } catch (e) {
      statusRequeste = statusRequest.serverExecption;

      print("خطأ في تحميل بيانات المرحلة الخامسة: $e");
    }

    update();
  }

  // ===================== Realtime =====================

  Future<void> RealtimeSubscription() async {
    final groupId = myservieces.sharedPref.getString("idgroup");

    if (groupId == null) return;

    supabaseCrud.subscribeToChanges(
      channelName: "stageroom",

      table: "fifth_Stage",

      columnFilter: "group_id",

      valueFilter: int.parse(groupId),

      onChange: (payload) async {
        print("========== REALTIME ==========");

        print("Event: ${payload.eventType}");

        print("Old Record: ${payload.oldRecord}");

        print("New Record: ${payload.newRecord}");

        // تحميل
        statusRequeste = statusRequest.loding;

        update();

        // حذف البيانات القديمة
        stageRecords.clear();

        // إعادة جلب البيانات
        await fetchStageRecords();

        // نجاح
        statusRequeste = statusRequest.success;

        // تحديث الواجهة
        update();
      },
    );
  }

  // ===================== اختيار ملف =====================

  Future<void> pickFile(int titleId) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final fileName = result.files.single.name;

      if (!fileName.toLowerCase().endsWith('.pdf')) {
        Get.snackbar(
          "خطأ",
          "يجب أن يكون الملف بصيغة PDF فقط",
          backgroundColor: Colors.red.shade100,
        );

        return;
      }

      pickedFiles[titleId] = File(result.files.single.path!);

      pickedFileNames[titleId] = fileName;

      update();
    }
  }

  // ===================== حذف الملف القديم =====================

  Future<void> _deleteOldFile(int titleId) async {
    final record = stageRecords[titleId];

    if (record != null && record['pdf_file'] != null) {
      final oldUrl = record['pdf_file'] as String;

      final oldFileName = oldUrl.split('/').last;

      try {
        final groupId =
            myservieces.sharedPref.getString("idgroup") ?? "unknown";

        await client.storage.from('stage5').remove([
          "group_$groupId/title_$titleId.pdf",
        ]);

        print("تم حذف الملف القديم: group_$groupId/title_$titleId.pdf");
      } catch (e) {
        print("فشل حذف الملف القديم: $e");

        try {
          await client.storage.from('stage5').remove([oldFileName]);
        } catch (_) {}
      }
    }
  }

  // ===================== رفع الملف =====================

  Future<String?> _uploadFile(int titleId) async {
    final file = pickedFiles[titleId];

    if (file == null) return null;

    final groupId = myservieces.sharedPref.getString("idgroup") ?? "unknown";

    final filename = "group_$groupId/title_$titleId.pdf";

    try {
      final fileBytes = await file.readAsBytes();

      await client.storage
          .from('stage5')
          .uploadBinary(
            filename,
            fileBytes,
            fileOptions: const FileOptions(contentType: 'application/pdf'),
          );

      final publicUrl = client.storage.from('stage5').getPublicUrl(filename);

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

  // ===================== إرسال الفصل =====================

  Future<void> submitChapter(int titleId) async {
    if (pickedFiles[titleId] == null) {
      Get.snackbar(
        "خطأ",
        "الرجاء إرفاق ملف PDF أولاً",
        backgroundColor: Colors.red.shade100,
      );

      return;
    }

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

      // حذف القديم
      await _deleteOldFile(titleId);

      // رفع الجديد
      final pdfUrl = await _uploadFile(titleId);

      if (pdfUrl == null) {
        statusRequeste = statusRequest.serverExecption;

        update();

        return;
      }

      final existingRecord = stageRecords[titleId];

      if (existingRecord != null) {
        // تحديث
        final res = await supabaseCrud.update(
          table: "fifth_Stage",

          match: {"stage5_id": existingRecord['stage5_id']},

          newData: {"pdf_file": pdfUrl, "approval": null},
        );

        if (res.status == statusRequest.success) {
          Get.snackbar(
            "تم",
            "تم تحديث الملف وإرساله للاعتماد",
            backgroundColor: Colors.green.shade50,
          );
        } else {
          throw res.error ?? "فشل التحديث";
        }
      } else {
        // إدراج
        final res = await supabaseCrud.insert(
          table: "fifth_Stage",

          data: {"group_id": groupId, "title_id": titleId, "pdf_file": pdfUrl},
        );

        if (res.status == statusRequest.success) {
          Get.snackbar(
            "تم",
            "تم إرسال الملف للاعتماد بنجاح",
            backgroundColor: Colors.green.shade50,
          );
        } else {
          throw res.error ?? "فشل الإدراج";
        }
      }

      // تنظيف
      pickedFiles.remove(titleId);

      pickedFileNames.remove(titleId);

      // إعادة تحميل البيانات
      await fetchStageRecords();

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

  // ===================== Lifecycle =====================

  @override
  void onInit() {
    super.onInit();

    _loadData().then((_) {
      RealtimeSubscription();
    });
  }
}

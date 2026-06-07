import 'package:get/get.dart';
import 'package:studentsystem/core/class/SupabaseCrud.dart';
import 'package:studentsystem/core/class/statusRequest.dart';
import 'package:studentsystem/core/servieces/servieces.dart';

class SixthStageController extends GetxController {
  Myservieces myservieces = Get.find();
  statusRequest statusRequeste = statusRequest.none;
  SupabaseCrud supabaseCrud = SupabaseCrud();

  Map<String, dynamic> data = {}; // بيانات المرحلة السادسة

  // ============ UI Helpers ============

  /// حالة المناقشة:
  /// - "approved"   → تمت المناقشة (approval == true)
  /// - "rejected"   → مرفوضة (approval == false)
  /// - "pending"    → لم تتم المناقشة بعد (لا يوجد بيانات)
  String get discussionStatus {
    if (data.isEmpty) return "pending";

    final approval = data["approval"];

    if (approval == true) return "approved";
    if (approval == false) return "rejected";

    return "pending";
  }

  /// هل تمت المناقشة؟
  bool get isApproved => data.isNotEmpty && data["approval"] == true;

  /// هل المناقشة مرفوضة؟
  bool get isRejected => data.isNotEmpty && data["approval"] == false;

  /// هل لم تتم المناقشة بعد؟
  bool get isPending => data.isEmpty || data["approval"] == null;

  /// تاريخ المناقشة
  String get discussionDate => data["discuss_date"] ?? "لم يتم تحديد موعد بعد";

  /// نسبة الإنجاز بناءً على حالة المناقشة
  double get completionPercentage {
    if (data.isEmpty) return 0.0;
    if (isApproved) return 1.0;
    if (isRejected) return 0.0;
    return 0.5; // في حالة لم يتم تحديد بعد لكن يوجد بيانات
  }

  /// نص حالة المناقشة للعرضvb
  String get statusText {
    switch (discussionStatus) {
      case "approved":
        return "تمت المناقشة";
      case "rejected":
        return "مرفوضة";
      case "pending":
      default:
        return "لم تتم المناقشة بعد";
    }
  }
  /// وصف حالة المناقشة
  String get statusDescription {
    switch (discussionStatus) { 
      case "approved":
        return "تمت المناقشة الثلاثية بنجاح";
      case "rejected":
        return "تم رفض المناقشة الثلاثية";
      case "pending":
      default:
        return "المناقشة الثلاثية لم تتم بعد";
    }
  }

  // ============ جلب البيانات ============

  Future<void> fetchStage6Data() async {
    statusRequeste = statusRequest.loding;
    update();

    final groupId = myservieces.sharedPref.getString("idgroup");

    if (groupId == null) {
      statusRequeste = statusRequest.serverExecption;
      update();
      return;
    }

    final response = await supabaseCrud.selectWhere(
      table: "stage 6 (trio discussion)",
      match: {"group_id": groupId},
    );

    if (response.status == statusRequest.success) {
      if (response.data != null && response.data!.isNotEmpty) {
        data = response.data![0]; // نخزن الصف الأول
        statusRequeste = statusRequest.success;
      } else {
        data = {}; // لا يوجد بيانات → لم تتم المناقشة بعد
        statusRequeste = statusRequest.success;
      }
    } else {
      statusRequeste = statusRequest.serverExecption;
    }

    update();
  }

  Future<void> realtimeSubscription() async {
    final groupId = myservieces.sharedPref.getString("idgroup");

    if (groupId == null) return;

    supabaseCrud.subscribeToChanges(
      channelName: "stageroom6",

      table: "stage 6 (trio discussion)",

      columnFilter: "group_id",

      valueFilter: int.parse(groupId),

      onChange: (payload) async {
        // تحميل
        statusRequeste = statusRequest.loding;
        data.clear;
        fetchStage6Data();
        update();

        statusRequeste = statusRequest.success;
        // تحديث الواجهة
        update();
      },
    );
  }

  // ============ Lifecycle ============

  @override
  void onInit() {
    fetchStage6Data();
    realtimeSubscription();
    super.onInit();
  }
}

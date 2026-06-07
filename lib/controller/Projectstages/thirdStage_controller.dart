import 'package:get/get.dart';
import 'package:studentsystem/core/class/SupabaseCrud.dart';
import 'package:studentsystem/core/class/statusRequest.dart';
import 'package:studentsystem/core/servieces/servieces.dart';

class ThirdstageController extends GetxController {
  Myservieces myservieces = Get.find();
  statusRequest statusRequeste = statusRequest.none;
  SupabaseCrud supabaseCrud = SupabaseCrud();

  Map<String, dynamic> data = {}; // نخزن بيانات المرحلة الثالثة هنا

  // ============ UI Helpers للمطابقة مع التصميم الجديد ============
  bool get isDiscussed => data["discussion_state"] == true;

  double get completionPercentage {
    if (data.isEmpty || data["discussion_percent"] == null) return 0.0;
    String percentStr = data["discussion_percent"]
        .toString()
        .replaceAll("%", "")
        .trim();
    double? val = double.tryParse(percentStr);
    return val != null ? val / 100.0 : 0.0;
  }

  String get discussionDate => data["discus_date"] ?? "لم يتم تحديد موعد بعد";

  List<Map<String, dynamic>> get notesList {
    if (data.isEmpty ||
        data["sprvsr_note"] == null ||
        data["sprvsr_note"].toString().isEmpty) {
      return [];
    }
    return [
      {"sender": "المشرف / لجنة المناقشة", "text": data["sprvsr_note"]},
    ];
  }
  // ================================================================

  // جلب بيانات المرحلة الثالثة فقط
  Future<void> fetchStage3Data() async {
    statusRequeste = statusRequest.loding;
    update();

    final response = await supabaseCrud.selectWhere(
      table: "third stage(discussion)",
      match: {"id_group": myservieces.sharedPref.getString("idgroup")},
    );

    if (response.status == statusRequest.success) {
      if (response.data != null && response.data!.isNotEmpty) {
        data = response.data![0]; // نخزن الصف الأول داخل الماب
        statusRequeste = statusRequest.success;
      } else {
        statusRequeste = statusRequest.success;
      }
    } else {
      statusRequeste = statusRequest.serverExecption;
    }

    update();
  }

  @override
  void onInit() {
    fetchStage3Data(); // عند فتح الصفحة يتم جلب البيانات مباشرة
    super.onInit();
  }
}

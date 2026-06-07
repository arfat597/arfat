import 'package:get/get.dart';
import 'package:studentsystem/core/class/SupabaseCrud.dart';
import 'package:studentsystem/core/class/statusRequest.dart';
import 'package:studentsystem/core/constens/Approutes.dart';
import 'package:studentsystem/core/servieces/servieces.dart';

class ProjectStagesController extends GetxController {
  statusRequest statusRequeste = statusRequest.none;
  SupabaseCrud supabaseCrud = SupabaseCrud();
  List stages = [];
  Myservieces myservieces = Get.find();
  stagesofProject() async {
    statusRequeste = statusRequest.loding;
    update();
    final response = await supabaseCrud.selectWhere(
      table: "stages",
      match: {"id_program": myservieces.sharedPref.getString("program")},
    );
    if (response.status == statusRequest.success) {
      if (response.data != null && response.data!.isNotEmpty) {
        stages = response.data!;
        print(response.data);
        statusRequeste = statusRequest.success;
        update();
      } 
    } else {
      statusRequeste = statusRequest.faliure;
    }
  }

  gotoo(index) {
    if (index == 0) {
      Get.toNamed(Approutes.firstStage);
    } else if (index == 1) {
      Get.toNamed(Approutes.secondStage);
    } else if (index == 2) {
      Get.toNamed(Approutes.thirdStage);
    } else if (index == 3) {
      Get.toNamed(Approutes.fourth_stage);
    } else if (index == 4) {
      Get.toNamed(Approutes.fifthStage);
    } else if (index == 5) {
      Get.toNamed(Approutes.sixthStage);
    } else if (index == 6) {
      Get.toNamed(Approutes.seventhStage);
    }
  }

  @override
  void onInit() {
    stagesofProject();
    super.onInit();
  }
}

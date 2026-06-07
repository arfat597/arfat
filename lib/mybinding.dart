import 'package:get/get.dart';
import 'package:studentsystem/core/class/SupabaseCrud.dart';
import 'package:studentsystem/core/class/crud.dart';

class Mybinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SupabaseCrud());
    Get.put(Crud());
  }
}

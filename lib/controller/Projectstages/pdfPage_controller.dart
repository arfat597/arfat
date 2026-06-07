import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PdfpageController extends GetxController {
  String? pdfUrl;

  @override
  void onInit() {
    final args = Get.arguments as Map<String, dynamic>?;
    pdfUrl = args?["pdf"];
    super.onInit();
  }

  /// دالة تنزيل الملف
  Future<void> downloadPdf() async {
    if (pdfUrl == null) {
      Get.snackbar("خطأ", "لا يوجد رابط ملف");
      return;
    }

    try {
      final response = await http.get(Uri.parse(pdfUrl!));
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/downloaded.pdf");
      await file.writeAsBytes(response.bodyBytes);
      Get.snackbar("تم", "تم تنزيل الملف وحفظه في ${file.path}");
    } catch (e) {
      Get.snackbar("خطأ", "فشل تنزيل الملف: $e");
    }
  }
}

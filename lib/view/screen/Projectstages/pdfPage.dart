import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsystem/controller/Projectstages/pdfPage_controller.dart';
import 'package:studentsystem/core/constens/AppColar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class Pdfpage extends StatelessWidget {
  const Pdfpage({super.key});
  @override
  Widget build(BuildContext context) {
    final PdfpageController controller = Get.put(PdfpageController());

    return Scaffold(
      backgroundColor: AppColar.white,
      appBar: AppBar(
        elevation: 4,
        backgroundColor: AppColar.primaryAPP,
        title: const Text(
          "📄 ملف PDF",
          style: TextStyle(color: AppColar.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColar.white),
            onPressed: () async {
              if (controller.pdfUrl != null) {
                final whatsappUrl = "https://wa.me/?text=${controller.pdfUrl}";
                if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                  await launchUrl(
                    Uri.parse(whatsappUrl),
                    mode: LaunchMode.externalApplication,
                  );
                  Get.snackbar("تم", "تم فتح واتساب لمشاركة الرابط");
                } else {
                  Get.snackbar("خطأ", "تعذر فتح واتساب");
                }
              }
            },
          ),
        ],
      ),
      body: GetBuilder<PdfpageController>(
        builder: (controller) => controller.pdfUrl == null
            ? const Center(child: CircularProgressIndicator())
            : SfPdfViewer.network(controller.pdfUrl!),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColar.primaryAPP,
        icon: const Icon(Icons.download, color: AppColar.white),
        label: const Text(
          "تنزيل الملف",
          style: TextStyle(color: AppColar.white),
        ),
        onPressed: () => controller.downloadPdf(),
      ),
    );
  }
}

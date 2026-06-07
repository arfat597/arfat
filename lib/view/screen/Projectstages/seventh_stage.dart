import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsystem/controller/Projectstages/seventh_stage_controller.dart';
import 'package:studentsystem/core/class/handlingdata.dart';
import 'package:studentsystem/core/constens/AppColar.dart';
import 'package:studentsystem/core/constens/Approutes.dart';
import 'package:studentsystem/view/widget/Home/CustomAppBar_home.dart';
import 'package:studentsystem/view/widget/Home/CustomDrawer_home.dart';

class SeventhStage extends StatelessWidget {
  const SeventhStage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SeventhStageController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColar.white,
        appBar: const CustomappbarHome(),
        drawer: const CustomdrawerHome(),
        body: SafeArea(
          child: GetBuilder<SeventhStageController>(
            builder: (controller) => HandlingdataRequest(
              statusRequeste: controller.statusRequeste,
              widget: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row with back arrow
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "تفاصيل المرحلة السابعة:\nتسليم ملف البحث النهائي",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1B3B70),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "قم برفع ملف البحث النهائي بصيغة PDF وأرشفته",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Color(0xFF1B3B70),
                          ),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // عرض الملف المؤرشف المعتمد سابقاً إذا كان موجوداً ومؤرشفاً
                    if (controller.isArchived) ...[
                      _buildArchivedFileCard(controller),
                    ] else ...[
                      // التحقق من صلاحية قائد الفريق
                      if (!controller.isGroupLeader) ...[
                        _buildNonLeaderWarningCard(),
                      ] else ...[
                        // بطاقة إرفاق ملف البحث للقائد
                        _buildUploadCard(controller),
                      ],
                    ],
                    const SizedBox(height: 20),

                    // بطاقة نسبة إنجاز المرحلة
                    _buildProgressCard(controller),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============ بطاقة الملف المؤرشف ============
  Widget _buildArchivedFileCard(SeventhStageController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          final url = controller.finalDocumentUrl;
          if (url.isNotEmpty) {
            Get.toNamed(Approutes.pdfPage, arguments: {"pdf": url});
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 1.5),
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFFF0FFF4),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "ملف البحث النهائي (مؤرشف)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B3B70),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "تم إرفاق وأرشفة ملف البحث النهائي بنجاح.",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.open_in_new, color: Color(0xFF1B3B70)),
            ],
          ),
        ),
      ),
    );
  }

  // ============ بطاقة تحذير لغير قائد الفريق ============
  Widget _buildNonLeaderWarningCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Column(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 48),
          const SizedBox(height: 12),
          const Text(
            "تنبيه هام",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF991B1B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "عذراً، لا يمكن إرفاق الملف إلا من قبل قائد المشروع.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF7F1D1D),
            ),
          ),
        ],
      ),
    );
  }

  // ============ بطاقة رفع الملف لقائد المشروع ============
  Widget _buildUploadCard(SeventhStageController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const Text(
            "إرفاق ملف البحث النهائي",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B3B70),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: controller.isSending ? null : controller.pickPdf,
            child: CustomPaint(
              painter: DashedBorderPainter(color: Colors.grey.shade400),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.transparent,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: controller.pickedPdfName != null
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 30,
                            )
                          : const Icon(
                              Icons.insert_drive_file,
                              color: Colors.grey,
                              size: 30,
                            ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.pickedPdfName ?? "اسحب الملف هنا أو اضغط\nللاختيار",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF1B3B70),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "PDF فقط",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (controller.pickedPdfName != null) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.isSending
                    ? null
                    : () => controller.submitFinalDocument(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: controller.isSending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send, color: Colors.white),
                label: Text(
                  controller.isSending ? "جاري الإرسال..." : "إرسال ملف البحث للاعتماد",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============ بطاقة نسبة الإنجاز للمرحلة ============
  Widget _buildProgressCard(SeventhStageController controller) {
    final percentage = controller.isArchived ? 1.0 : 0.0;
    final percentText = "${(percentage * 100).toInt()}%";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              "نسبة إنجاز المرحلة",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B3B70),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                percentText,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(
                  "التقدم الكلي للمرحلة",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CustomPainter لرسم إطار متقطع حول منطقة سحب وإفلات الملف
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    this.color = Colors.grey,
    this.strokeWidth = 1.0,
    this.dashWidth = 6.0,
    this.dashSpace = 5.0,
    this.borderRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    var path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    Path dashPath = Path();
    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

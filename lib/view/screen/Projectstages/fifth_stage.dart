import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsystem/controller/Projectstages/fifth_stage_controller.dart';
import 'package:studentsystem/core/class/handlingdata.dart';
import 'package:studentsystem/core/constens/AppColar.dart';
import 'package:studentsystem/core/constens/Approutes.dart';
import 'package:studentsystem/view/widget/Home/CustomAppBar_home.dart';
import 'package:studentsystem/view/widget/Home/CustomDrawer_home.dart';

class FifthStage extends StatelessWidget {
  const FifthStage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FifthStageController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColar.white,
        appBar: const CustomappbarHome(),
        drawer: const CustomdrawerHome(),
        body: SafeArea(
          child: GetBuilder<FifthStageController>(
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
                                "تفاصيل المرحلة الخامسة: كتابة التقرير\nالنهائي",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1B3B70),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "قم برفع ملفات الفصول والملاحق بصيغة PDF",
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

                    // Progress Card
                    _buildProgressCard(controller),
                    const SizedBox(height: 24),

                    // Chapter Cards
                    ...controller.titles.map(
                      (title) => _buildChapterCard(
                        controller,
                        title['title_id'] as int,
                        title['title_name'] as String,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============ بطاقة نسبة الإنجاز ============
  Widget _buildProgressCard(FifthStageController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF3FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "نسبة الإنجاز",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B3B70),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${controller.approvedCount} من ${controller.totalChapters} فصول معتمدة",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
              Text(
                "${(controller.completionPercentage * 100).toInt()}%",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: controller.completionPercentage,
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "${(controller.completionPercentage * 100).toInt()}%",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.blue.shade200),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                controller.approvedCount.toString(),
                "معتمد",
                Colors.teal,
              ),
              _buildStatItem(
                controller.pendingCount.toString(),
                "قيد المراجعة",
                Colors.orange,
              ),
              _buildStatItem(
                controller.rejectedCount.toString(),
                "مرفوض",
                Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
        ),
      ],
    );
  }

  // ============ بطاقة كل فصل ============
  Widget _buildChapterCard(
    FifthStageController controller,
    int titleId,
    String titleName,
  ) {
    final String status = controller.getApprovalStatus(titleId);
    final String? pdfUrl = controller.getPdfUrl(titleId);
    final String? note = controller.getSupervisorNote(titleId);
    final String? pickedFileName = controller.pickedFileNames[titleId];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titleName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B3B70),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Colors.blueAccent,
                  size: 20,
                ),
              ),
            ],
          ),

          // شريط الملف الموجود سابقاً
          if (pdfUrl != null) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: () {
                Get.toNamed(Approutes.pdfPage, arguments: {"pdf": pdfUrl});
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue.shade50,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "ملف $titleName المرفوع سابقاً",
                        style: const TextStyle(color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.open_in_new, color: Colors.blueAccent),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Upload Area
          GestureDetector(
            onTap: () => controller.pickFile(titleId),
            child: CustomPaint(
              painter: DashedBorderPainter(color: Colors.grey.shade400),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.transparent,
                ),
                child: Column(
                  children: [
                    Icon(
                      pickedFileName != null
                          ? Icons.check_circle_outline
                          : Icons.cloud_upload_outlined,
                      color: pickedFileName != null
                          ? Colors.green
                          : Colors.grey.shade500,
                      size: 36,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      pickedFileName ?? "اسحب ملف PDF هنا أو اضغط للاختيار",
                      style: TextStyle(
                        color: pickedFileName != null
                            ? Colors.green
                            : Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
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
          const SizedBox(height: 16),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => controller.submitChapter(titleId),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent.shade200,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              icon: const Icon(
                Icons.send_outlined,
                color: Colors.white,
                size: 20,
              ),
              label: Text(
                "إرسال $titleName",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Status Indicator
          _buildStatusIndicator(status, note),
        ],
      ),
    );
  }

  // ============ مؤشر حالة الاعتماد ============
  Widget _buildStatusIndicator(String status, String? note) {
    Color bgColor;
    Color borderColor;
    Color textColor;
    IconData iconData;
    String statusText;

    switch (status) {
      case "approved":
        bgColor = const Color(0xFFF0FDF4);
        borderColor = Colors.green.shade200;
        textColor = Colors.green.shade700;
        iconData = Icons.check_circle_outline;
        statusText = "تم الاعتماد";
        break;
      case "rejected":
        bgColor = const Color(0xFFFEF2F2);
        borderColor = Colors.red.shade200;
        textColor = Colors.red.shade700;
        iconData = Icons.cancel_outlined;
        statusText = "مرفوض";
        break;
      case "pending":
        bgColor = const Color(0xFFFFFBEB);
        borderColor = Colors.amber.shade200;
        textColor = Colors.amber.shade700;
        iconData = Icons.access_time;
        statusText = "في انتظار الاعتماد";
        break;
      case "not_submitted":
      default:
        bgColor = const Color(0xFFFFFBEB);
        borderColor = Colors.amber.shade200;
        textColor = Colors.amber.shade700;
        iconData = Icons.access_time;
        statusText = "في انتظار الاعتماد";
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "تقرير المرحلة",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    statusText,
                    style: TextStyle(fontSize: 12, color: textColor),
                  ),
                ],
              ),
              Icon(iconData, color: textColor, size: 24),
            ],
          ),
          if (note != null && note.isNotEmpty) ...[
            const SizedBox(height: 12),
            Divider(color: borderColor),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 16,
                  color: Colors.grey.shade700,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "ملاحظة المشرف: $note",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// CustomPainter for dashed border
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

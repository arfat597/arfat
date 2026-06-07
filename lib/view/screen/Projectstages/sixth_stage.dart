import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsystem/controller/Projectstages/sixth_stage_controller.dart';
import 'package:studentsystem/core/constens/AppColar.dart';
import 'package:studentsystem/view/widget/Home/CustomAppBar_home.dart';
import 'package:studentsystem/view/widget/Home/CustomDrawer_home.dart';

class SixthStage extends StatelessWidget {
  const SixthStage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SixthStageController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColar.white,
        appBar: const CustomappbarHome(),
        drawer: const CustomdrawerHome(),
        body: SafeArea(
          child: GetBuilder<SixthStageController>(
            builder: (ctrl) {
              // حالة التحميل
              if (ctrl.statusRequeste.toString().contains("loding")) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
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
                                "تفاصيل المرحلة السادسة: المناقشة الثلاثية",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1B3B70),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "متابعة حالة المناقشة والملاحظات",
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

                    // Card 1: Discussion Status (حالة المناقشة)
                    _buildStatusCard(ctrl),
                    const SizedBox(height: 24),

                    // Card 2: Progress (نسبة إنجاز المناقشة)
                    _buildProgressCard(ctrl),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ============ بطاقة حالة المناقشة ============
  Widget _buildStatusCard(SixthStageController ctrl) {
    // تحديد الألوان والأيقونات بناءً على حالة المناقشة
    Color cardBgColor;
    Color cardBorderColor;
    Color iconColor;
    IconData statusIcon;

    switch (ctrl.discussionStatus) {
      case "approved":
        cardBgColor = const Color(0xFFF0FFF4);
        cardBorderColor = const Color(0xFF4ADE80);
        iconColor = const Color(0xFF16A34A);
        statusIcon = Icons.check_circle_outline;
        break;
      case "rejected":
        cardBgColor = const Color(0xFFFEF2F2);
        cardBorderColor = const Color(0xFFFCA5A5);
        iconColor = const Color(0xFFDC2626);
        statusIcon = Icons.cancel_outlined;
        break;
      case "pending":
      default:
        cardBgColor = const Color(0xFFFEFCE8);
        cardBorderColor = const Color(0xFFFDE047);
        iconColor = const Color(0xFFD97706);
        statusIcon = Icons.watch_later_outlined;
        break;
    }

    return Container(
      width: double.infinity,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "حالة المناقشة",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B3B70),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF3FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.people_outline,
                  color: Color(0xFF2563EB),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // بطاقة الحالة الديناميكية
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cardBorderColor, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ctrl.statusText,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B3B70),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ctrl.statusDescription,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(statusIcon, color: iconColor, size: 26),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // بطاقة التاريخ
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "التاريخ",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ctrl.discussionDate,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B3B70),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  color: Color(0xFF2563EB),
                  size: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============ بطاقة نسبة إنجاز المناقشة ============
  Widget _buildProgressCard(SixthStageController ctrl) {
    final percentage = ctrl.completionPercentage;
    final percentText = "${(percentage * 100).toInt()}%";

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
          const Text(
            "نسبة إنجاز المناقشة",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B3B70),
            ),
          ),
          const SizedBox(height: 16),

          // Progress Bar Row
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: percentage,
                    minHeight: 10,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF2563EB),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                percentText,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

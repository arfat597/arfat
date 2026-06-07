import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsystem/controller/Projectstages/thirdstage_controller.dart';
import 'package:studentsystem/core/class/handlingdata.dart';
import 'package:studentsystem/core/constens/AppColar.dart';
import 'package:studentsystem/view/widget/Home/CustomAppBar_home.dart';
import 'package:studentsystem/view/widget/Home/CustomDrawer_home.dart';

class Thirdstage extends StatelessWidget {
  const Thirdstage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ThirdstageController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColar.white,
        appBar: const CustomappbarHome(),
        drawer: const CustomdrawerHome(),
        body: GetBuilder<ThirdstageController>(
          builder: (controller) => HandlingdataRequest(
            statusRequeste: controller.statusRequeste,
            widget: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🏷️ العنوان الرئيسي
                  Text(
                    "المرحلة الثالثة: مناقشة الخطة",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColar.primaryAPP,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🟢 حالة المناقشة
                  _buildCard(
                    icon: Icons.forum,
                    title: "حالة المناقشة",
                    child: Text(
                      controller.data["discussion_state"] == true
                          ? "✔️ تمت المناقشة"
                          : "⏳ لم تتم المناقشة بعد",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: controller.data["discussion_state"] == true
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 📊 نسبة الإنجاز
                  _buildCard(
                    icon: Icons.bar_chart,
                    title: "نسبة الإنجاز",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value:
                              double.tryParse(
                                (controller.data["discussion_percent"] ?? "0")
                                    .toString()
                                    .replaceAll("%", ""),
                              )! /
                              100,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.blueAccent,
                          minHeight: 12,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${controller.data["discussion_percent"] ?? "0%"} مكتملة",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 📋 تفاصيل المناقشة
                  _buildCard(
                    icon: Icons.info_outline,
                    title: "تفاصيل المناقشة",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.date_range, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              "تاريخ: ${controller.data["discus_date"] ?? "غير محدد"}",
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 📝 الملاحظات
                  _buildCard(
                    icon: Icons.note_alt,
                    title: "ملاحظات المناقشة",
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        controller.data["sprvsr_note"] ??
                            "لا توجد ملاحظات حالياً.",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🛠️ دالة بناء الكارد بشكل أنيق
  Widget _buildCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColar.primaryAPP),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

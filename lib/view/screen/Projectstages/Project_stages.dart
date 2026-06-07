import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsystem/controller/Projectstages/Project_stages_controller.dart';
import 'package:studentsystem/core/class/handlingdata.dart';
import 'package:studentsystem/view/widget/Home/CustomAppBar_home.dart';
import 'package:studentsystem/view/widget/Home/CustomDrawer_home.dart';
import 'package:studentsystem/core/constens/AppColar.dart';

class ProjectStages extends StatelessWidget {
  const ProjectStages({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(ProjectStagesController());
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColar.white,
        appBar: const CustomappbarHome(),
        drawer: const CustomdrawerHome(),
        body: GetBuilder<ProjectStagesController>(
          builder: (controller) => HandlingdataRequest(
            statusRequeste: controller.statusRequeste,
            widget: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "مراحل المشروع",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColar.primaryAPP,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "جدول زمني لمراحل إنجاز مشروع التخرج",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.stages.length,
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // الخط الجانبي مع الأرقام
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: AppColar.primaryAPP,
                                  child: Text(
                                    "${index + 1}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (index != controller.stages.length)
                                  Container(
                                    width: 2,
                                    height: 100,
                                    color: Colors.grey.shade400,
                                  ),
                              ],
                            ),
                            const SizedBox(width: 12),

                            // تفاصيل المرحلة
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColar.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColar.primaryAPP, // لون البوردر
                                    width: 0.5, // سمك البوردر
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      blurRadius: 13,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${controller.stages[index]["stage_name"]}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    Row(
                                      children: [
                                        Icon(
                                          controller.stages[index]["stage_isactive"] ==
                                                  true
                                              ? Icons.circle
                                              : Icons.circle_outlined,
                                          color:
                                              controller
                                                      .stages[index]["stage_isactive"] ==
                                                  true
                                              ? Colors.green
                                              : Colors.grey,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          controller.stages[index]["stage_isactive"] ==
                                                  true
                                              ? "مفعلة"
                                              : "غير مفعلة",
                                          style: TextStyle(
                                            color:
                                                controller
                                                        .stages[index]["stage_isactive"] ==
                                                    true
                                                ? Colors.green
                                                : Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),

                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month_outlined,
                                          size: 16,
                                          color: Colors.blueGrey,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          "${controller.stages[index]["start_date"]}",
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month_outlined,
                                          size: 16,
                                          color: Colors.blueGrey,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          "${controller.stages[index]["end_date"]}",
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.center,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColar.primaryAPP,
                                        ),
                                        onPressed: () {
                                          // هنا تفتح شاشة التفاصيل الخاصة بالمرحلة
                                          controller.gotoo(index);
                                        },
                                        child: const Text(
                                          "عرض التفاصيل",
                                          style: TextStyle(
                                            color: AppColar.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

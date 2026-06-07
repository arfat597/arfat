import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsystem/controller/Projectstages/frist_stages_controller.dart';
import 'package:studentsystem/core/class/handlingdata.dart';
import 'package:studentsystem/core/constens/AppColar.dart';
import 'package:studentsystem/view/widget/Home/CustomAppBar_home.dart';
import 'package:studentsystem/view/widget/Home/CustomDrawer_home.dart';

class FirstStage extends StatelessWidget {
  const FirstStage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FristStagesController());
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColar.white,
        appBar: const CustomappbarHome(),
        drawer: const CustomdrawerHome(),
        body: GetBuilder<FristStagesController>(
          builder: (controller) => Handlingdataview(
            statusRequeste: controller.statusRequeste,
            widget: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "المرحلة الأولى: اختيار عنوان البحث",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "استكمل الخطوات التالية لبدء مشروع التخرج",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // 1. اختيار الفريق
                  _buildCard(
                    number: "1",
                    title: "اختيار الفريق",
                    description:
                        "اختر لإنشاء فريق جديد أو الانضمام إلى فريق موجود",
                    children: [
                      InkWell(
                        onTap: () {
                          if (controller.grop == false) {
                            Get.defaultDialog(
                              title: "إنشاء فريق جديد",
                              titleStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent, // لون العنوان
                              ),
                              backgroundColor: Colors.white, // خلفية النافذة
                              radius: 15, // زوايا مستديرة للنافذة
                              content: Column(
                                children: [
                                  TextField(
                                    controller: controller.groupNameController,
                                    decoration: InputDecoration(
                                      labelText: "اسم الفريق",
                                      labelStyle: const TextStyle(
                                        color: Colors.blueAccent,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              textConfirm: "تأكيد",
                              textCancel: "إلغاء",
                              buttonColor: Colors.blueAccent, // لون زر التأكيد
                              cancelTextColor:
                                  Colors.redAccent, // لون زر الإلغاء
                              confirmTextColor: Colors.white,
                              onConfirm: () {
                                String groupName = controller
                                    .groupNameController
                                    .text
                                    .trim();
                                if (groupName.isNotEmpty) {
                                  Get.back();
                                } else {
                                  Get.snackbar(
                                    "خطأ",
                                    "الرجاء إدخال اسم الفريق",
                                    backgroundColor: Colors.red.shade100,
                                    colorText: Colors.black,
                                    icon: const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  );
                                }
                              },
                              onCancel: () {
                                Get.back();
                              },
                            );
                          }
                        },
                        child: _buildOption(
                          icon: Icons.group_add,
                          title: "إنشاء فريق جديد",
                          subtitle: "قم بإنشاء فريق وأضف أعضاء",
                        ),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () {
                          if (controller.grop == false) {
                            Get.defaultDialog(
                              title: "اختر فريق للانضمام",
                              titleStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                              content: SizedBox(
                                width: double.infinity,
                                height: 300, // ارتفاع ثابت
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: controller.data1.map<Widget>((
                                      group,
                                    ) {
                                      return Card(
                                        color: Colors
                                            .blue
                                            .shade50, // خلفية الكارد بلون فاتح
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          side: const BorderSide(
                                            color: Colors.blueAccent,
                                            width: 1,
                                          ),
                                        ),
                                        child: ListTile(
                                          leading: const Icon(
                                            Icons.group,
                                            color: Colors.blueAccent,
                                          ),
                                          title: Text(
                                            "الفريق: ${group['group_name']}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "القائد: ${group['stud_name']}",
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                "المشرف: ${group['sprvsr_name']}",
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            controller.selectedGroupId =
                                                group['group_id'];
                                            controller.selectgrop();
                                            Get.back();
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              backgroundColor: Colors.white,
                              radius: 15,
                            );
                          }
                        },
                        child: _buildOption(
                          icon: Icons.group,
                          title: "الانضمام إلى الفريق",
                          subtitle: "انضم إلى فريق موجود",
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "تم اختيار الانضمام للفريق",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _buildCard(
                    number: "2",
                    title: "اختيار المشرف",
                    description: "اختر المشرف الأكاديمي لمشروع التخرج",
                    children: [
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "اختر المشرف الأكاديمي لمشروع التخرج",
                        ),
                        items: controller.supervi.map<DropdownMenuItem<int>>((
                          supervisor,
                        ) {
                          return DropdownMenuItem<int>(
                            value: supervisor['sprvsr_id'],
                            child: Text("د. ${supervisor['sprvsr_name']}"),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.selectedSupervisorId = value;
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _buildCard(
                    number: "3",
                    title: "عنوان البحث ووصفه",
                    description:
                        "أدخل عنوان البحث والوصف التفصيلي (يتطلب اعتماد من المشرف ومسؤول البرنامج ورئيس القسم)",
                    children: [
                      TextFormField(
                        controller: controller.researchTitleController,
                        decoration: const InputDecoration(
                          labelText: "عنوان البحث *",
                          hintText: "أدخل عنوان البحث...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: controller.researchDescriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: "وصف البحث *",
                          hintText: "اكتب وصفًا تفصيليًا للبحث...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (controller.grop == true) {
                            Get.snackbar(
                              "خطأ",
                              "انت موجود ظمن فريق في الوقت الحالي",
                              backgroundColor: Colors.red.shade100,
                              colorText: Colors.black,
                              icon: const Icon(
                                Icons.error,
                                color: Colors.green,
                              ),
                            );
                          } else {
                            controller.newgrop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColar.primaryAPP,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text(
                          "إرسال للاعتماد",
                          style: TextStyle(
                            color: AppColar.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildCard(
                    number: "4",
                    title: "تفاصيل المشروع والموافقات",
                    description:
                        "هنا يظهر عنوان المشروع، وصفه، والموافقات مع الملاحظات",
                    children: [
                      if (controller.info.isNotEmpty) ...[
                        Text(
                          "عنوان المشروع: ${controller.info[0]['research_title'] ?? "غير مدخل"}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          "الوصف: ${controller.info[0]['research_description'] ?? "غير مدخل"}",
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const Divider(height: 20, thickness: 1),

                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.blueAccent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "موافقة المشرف: ${controller.approvalText(controller.info[0]['sprvsr_approval'])}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "ملاحظة المشرف: ${controller.info[0]['sprvsr_note'] ?? "لا توجد"}",
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 12),

                       
                        Row(
                          children: [
                            const Icon(
                              Icons.manage_accounts,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "موافقة مسؤول البرنامج: ${controller.approvalText(controller.info[0]['prgrm_mngr_approval'])}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "ملاحظة المسؤول: ${controller.info[0]['prgrm_mngr_note'] ?? "لا توجد"}",
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.school, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "موافقة رئيس القسم: ${controller.approvalText(controller.info[0]['head_dep_approval'])}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "ملاحظة رئيس القسم: ${controller.info[0]['head_dep_note'] ?? "لا توجد"}",
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.defaultDialog(
                                title: "تعديل بيانات البحث",
                                content: Column(
                                  children: [
                                    TextFormField(
                                      controller: controller.researchTitleinfo
                                        ..text =
                                            controller
                                                .info[0]['research_title'] ??
                                            "",
                                      decoration: const InputDecoration(
                                        labelText: "عنوان البحث",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: controller.researchDescrinfo
                                        ..text = controller
                                            .info[0]['research_description'],

                                      maxLines: 4,
                                      decoration: const InputDecoration(
                                        labelText: "وصف البحث",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                                textConfirm: "تعديل",
                                textCancel: "إلغاء",
                                onConfirm: () {
                                  if (controller
                                          .researchTitleinfo
                                          .text
                                          .isEmpty &&
                                      controller
                                          .researchDescrinfo
                                          .text
                                          .isEmpty) {
                                    Get.snackbar(
                                      "تنبيه ⚠️",
                                      "يجب عليك إدخال البيانات الجديدة",
                                      backgroundColor: Colors.orange.shade100,
                                      colorText: Colors.black,
                                      icon: const Icon(
                                        Icons.warning,
                                        color: Colors.orange,
                                      ),
                                    );
                                  } else {
                                    controller.updatinfo();
                                    Get.back();
                                  }
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            icon: const Icon(Icons.edit, color: Colors.white),
                            label: const Text("تعديل"),
                          ),
                        ),
                      ] else ...[
                        const Text("لا توجد بيانات للمرحلة الأولى حالياً"),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =================== Widgets ===================
  Widget _buildCard({
    required String number,
    required String title,
    required String description,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$number. $title",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(description, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required String subtitle,
    bool selected = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: selected ? Colors.blue : AppColar.primaryAPP,
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(subtitle, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}

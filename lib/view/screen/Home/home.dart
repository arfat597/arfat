import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:studentsystem/controller/Home/Home_controller.dart';
import 'package:studentsystem/core/class/handlingdata.dart';
import 'package:studentsystem/core/constens/AppColar.dart';
import 'package:studentsystem/view/widget/Home/CustomAppBar_home.dart';
import 'package:studentsystem/view/widget/Home/CustomDrawer_home.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColar.white,
        appBar: CustomappbarHome(),
        drawer: CustomdrawerHome(),
        body: GetBuilder<HomeController>(
          builder: (controller) => Handlingdataview(
            statusRequeste: controller.statusRequeste,
            widget: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "مرحباً، ",
                              style: TextStyle(
                                fontSize: 22,
                                color: AppColar.primaryAPP,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${controller.username}",
                              style: TextStyle(
                                fontSize: 18,
                                //color: AppColar.primaryAPP,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3),
                        Text(
                          "متابعة مشروع التخرج والتقدم المحرز",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,

                            color: const Color.fromARGB(255, 148, 146, 146),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  _buildSmallCard(
                    title: "حالة المشروع",
                    child: Text(
                      controller.data['group_state'] ?? "لا يوجد معلومات",
                      style: TextStyle(
                        color: AppColar.primaryAPP,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildSmallCard(
                    title: "المشرف الأكاديمي",
                    child: controller.data['sprvsr_name'] != null
                        ? ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: AppColar.primaryAPP,
                              child: Text(
                                "د",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              'د.'
                              "${controller.data['sprvsr_name']}",
                            ),
                            subtitle: Text(
                              "${controller.data['sprvsr_email']}",
                            ),
                          )
                        : Text(
                            "لم يتم اختيار مشرف بعد",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColar.grey,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  _buildSmallCard(
                    title: "نسبة الإنجاز",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.data['group_progress'] != null
                              ? "${controller.percentage}"
                                    '%'
                              : "0",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColar.primaryAPP,
                          ),
                        ),
                        SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: controller.data['group_progress'] ?? 0.0,
                            minHeight: 8,
                            backgroundColor: Colors.grey.shade300,
                            color: AppColar.primaryAPP,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "نظرة عامة على المشروع",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "عنوان المشروع",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(
                          //بعد
                          controller.data['group_name'] ?? "لا يوجد معلومات",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 21, 21, 21),
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "وصف المشروع",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(
                          controller.data['group_name'] ?? "لا يوجد معلومات",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 10),
                        Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                          indent: 5,
                          endIndent: 5,
                        ),
                        Text(
                          "المرحلة الحالية: ${controller.data['stage_name_current']}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColar.primaryAPP,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "حالة التسليم: تم التسليم في الموعد",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "أعضاء الفريق",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _teamMember(
                          name: "عرفات القريش",
                          role: "مطور Flutter",
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 12),
                        _teamMember(
                          name: "محمد أحمد",
                          role: "محلل نظم",
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 12),
                        _teamMember(
                          name: "سارة خالد",
                          role: "مصممة UI/UX",
                          color: Colors.green,
                        ),
                      ],
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

  // =================== Widgets ===================
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSmallCard({required String title, required Widget child}) {
    return _buildCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _teamMember({
    required String name,
    required String role,
    required Color color,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: color,
          child: Text(
            name[0],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(role, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}

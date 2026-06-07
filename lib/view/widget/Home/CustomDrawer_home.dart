import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsystem/core/constens/AppColar.dart';
import 'package:studentsystem/core/constens/Approutes.dart';
import 'package:studentsystem/core/function/Logout.dart';

class CustomdrawerHome extends StatelessWidget {
  const CustomdrawerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blue.shade800,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColar.primaryAPP, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'القائمة الرئيسية',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.white),
              title: const Text(
                "لوحة التحكم",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Get.offAllNamed(Approutes.home);
              },
            ),
            ListTile(
              leading: const Icon(Icons.timeline, color: Colors.white),
              title: const Text(
                "مراحل المشروع",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Get.toNamed(Approutes.projectstages);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart, color: Colors.white),
              title: const Text(
                "التقارير",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.note, color: Colors.white),
              title: const Text(
                "الملاحظات",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.attach_file, color: Colors.white),
              title: const Text(
                "الملفات المرفوعة",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.white),
              title: const Text(
                "المحادثة",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Get.toNamed(Approutes.chats);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text(
                "الإعدادات",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
            ),

            const Divider(color: Colors.white54),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "تسجيل الخروج",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}

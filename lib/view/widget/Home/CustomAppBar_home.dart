import 'package:flutter/material.dart';
import 'package:studentsystem/core/constens/AppColar.dart';

class CustomappbarHome extends StatelessWidget implements PreferredSizeWidget {
  const CustomappbarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColar.white,
      elevation: 0,
      automaticallyImplyLeading: false,

      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),

      title: const Text(
        "اداره المشاريع",
        style: TextStyle(
          color: AppColar.primaryAPP,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      actions: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColar.primaryAPP,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text(
            "م",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10),
        Stack(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, color: Colors.black),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.logout, color: Colors.black),
        ),
      ],
    );
  }

  // هذا الجزء ضروري ليعرف Flutter حجم الـ AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

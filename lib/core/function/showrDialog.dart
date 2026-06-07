import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsystem/core/constens/AppColar.dart';

void showLoginrDialog(
  bool colerIcon,
  IconData icondata,
  String textup,
  String textMsug,
  bool button,
  void Function()? onPressedcacel,
  void Function()? onPressedOK,
) {
  showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: colerIcon ? AppColar.green : Colors.redAccent,
                child: Icon(icondata, size: 40, color: Colors.white),
              ),
              SizedBox(height: 20),

              // العنوان
              Text(
                textup,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),

              // الرسالة
              Text(
                textMsug,
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // الأزرار
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (button)
                    ElevatedButton(
                      onPressed: onPressedcacel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "إلغاء",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: onPressedOK,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "موافق",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

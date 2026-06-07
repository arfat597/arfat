import 'package:flutter/material.dart';
import 'package:studentsystem/core/constens/AppColar.dart';

class Materialbutton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final IconData icondata;
  const Materialbutton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icondata,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: MaterialButton(
        onPressed: onPressed,
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: AppColar.primaryAPP,
        textColor: AppColar.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5),
            Icon(icondata),
          ],
        ),
      ),
    );
  }
}

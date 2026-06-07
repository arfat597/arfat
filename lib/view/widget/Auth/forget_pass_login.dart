import 'package:flutter/material.dart';
import 'package:studentsystem/core/constens/AppColar.dart';

class ForgetPassLogin extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const ForgetPassLogin({super.key, this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 15),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            color: AppColar.primaryAPP,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:studentsystem/core/constens/AppColar.dart';

class Costomtextformauth extends StatelessWidget {
  final String textlabel;
  final String texthint;
  final IconData icondata;
  final TextEditingController mycontroller;
  final String? Function(String?) validator;
  final bool? obscureText;
  final void Function()? onTapIcon;
  const Costomtextformauth({
    super.key,
    required this.textlabel,
    required this.texthint,
    required this.icondata,
    required this.mycontroller,
    required this.validator,
    this.obscureText,
    this.onTapIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        obscureText: obscureText == null || obscureText == false ? false : true,

        validator: validator,
        controller: mycontroller,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),

          label: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              textlabel,
              style: TextStyle(fontSize: 13, fontFamily: "Cairo"),
            ),
          ),

          hintStyle: TextStyle(fontSize: 14),
          hintText: texthint,
          suffix: InkWell(
            onTap: onTapIcon,
            child: Icon(icondata, color: AppColar.primaryAPP),
          ),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:studentsystem/core/class/statusRequest.dart';
import 'package:studentsystem/core/constens/Appimage.dart';
class Handlingdataview extends StatelessWidget {
  const Handlingdataview(
      {super.key, required this.statusRequeste, required this.widget});
  final statusRequest statusRequeste;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return statusRequeste == statusRequest.loding
        ? Center(
            child: Lottie.asset(Appimage.lottieLodin, width: 250, height: 250))
        : statusRequeste == statusRequest.ooflinefaliur
            ? Center(
                child: Lottie.asset(Appimage.lottieoofline,
                    width: 250, height: 250))
            : statusRequeste == statusRequest.serverfaliur
                ? Center(
                    child: Lottie.asset(Appimage.lottieservarfilur,
                        width: 250, height: 250))
                : statusRequeste == statusRequest.faliure
                    ? Center(
                        child: Lottie.asset(Appimage.lottienodata,
                            width: 250, height: 250))
                    : widget;
  }
}

class HandlingdataRequest extends StatelessWidget {
  const HandlingdataRequest(
      {super.key, required this.statusRequeste, required this.widget});
  final statusRequest statusRequeste;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return statusRequeste == statusRequest.loding
        ? Center(
            child: Lottie.asset(Appimage.lottieLodin, width: 250, height: 250))
        : statusRequeste == statusRequest.ooflinefaliur
            ? Center(
                child: Lottie.asset(Appimage.lottieoofline,
                    width: 250, height: 250))
            : statusRequeste == statusRequest.serverfaliur
                ? Center(
                    child: Lottie.asset(Appimage.lottieservarfilur,
                        width: 250, height: 250))
                : widget;
  }
}

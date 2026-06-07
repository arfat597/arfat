import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:studentsystem/core/constens/Approutes.dart';
import 'package:studentsystem/core/middeleware/middeleware.dart';
import 'package:studentsystem/view/screen/Auth/forgetpassword.dart';
import 'package:studentsystem/view/screen/Auth/login.dart';
import 'package:studentsystem/view/screen/Auth/resetPassword.dart';
import 'package:studentsystem/view/screen/Auth/verfiyCode.dart';
import 'package:studentsystem/view/screen/Home/home.dart';
import 'package:studentsystem/view/screen/Projectstages/Project_stages.dart';
import 'package:studentsystem/view/screen/Projectstages/fifth_stage.dart';
import 'package:studentsystem/view/screen/Projectstages/sixth_stage.dart';
import 'package:studentsystem/view/screen/Projectstages/seventh_stage.dart';
import 'package:studentsystem/view/screen/Projectstages/fourth_stage.dart';
import 'package:studentsystem/view/screen/Projectstages/frist_stages.dart';
import 'package:studentsystem/view/screen/Projectstages/pdfPage.dart';
import 'package:studentsystem/view/screen/Projectstages/second_stage.dart';
import 'package:studentsystem/view/screen/Projectstages/thirdStage.dart';
import 'package:studentsystem/view/screen/chats/chats.dart';

List<GetPage<dynamic>> routes = [
  GetPage(
    middlewares: [Mymiddelware()],
    name: Approutes.login,
    page: () => const Login(),
  ),
  GetPage(name: Approutes.forgetpassowrd, page: () => const Forgetpassword()),
  GetPage(name: Approutes.verfiyCode, page: () => const Verfiycode()),
  GetPage(name: Approutes.resetPassword, page: () => const Resetpassword()),
  GetPage(name: Approutes.home, page: () => const Home()),
  GetPage(name: Approutes.projectstages, page: () => const ProjectStages()),
  GetPage(name: Approutes.firstStage, page: () => const FirstStage()),
  GetPage(name: Approutes.secondStage, page: () => const SecondStage()),
  GetPage(name: Approutes.pdfPage, page: () => const Pdfpage()),
  GetPage(name: Approutes.thirdStage, page: () => const Thirdstage()),
  GetPage(name: Approutes.fourth_stage, page: () => const FourthStage()),
  GetPage(name: Approutes.fifthStage, page: () => const FifthStage()),
  GetPage(name: Approutes.sixthStage, page: () => const SixthStage()),
  GetPage(name: Approutes.seventhStage, page: () => const SeventhStage()),
  GetPage(name: Approutes.chats, page: () => const ChatsScreen()),
];

import 'package:get/get.dart';

validInpot(String val, int min, int max, String type) {
  if (type == "username") {
    if (!GetUtils.isUsername(val)) {
      return "Not Valide Username";
    }
  }

  if (type == "pasword") {
    if (!GetUtils.isPassport(val)) {
      return "لا يمكن ترك الحقل فارغ";
    }
  }

  if (type == "phone") {
    if (!GetUtils.isPhoneNumber(val)) {
      return "لا يمكن ترك الحقل فارغ";
    }
  }

  if (type == "email") {
    if (!GetUtils.isEmail(val)) {
      return "Not Valide Emali";
    }
  }

  if (val.length < min) {
    return "can`t be less than $max";
  }
  if (val.length > max) {
    return "can`t be larger than $min";
  }
  if (val.isEmpty) {
    return "can`t be Empty";
  }
}

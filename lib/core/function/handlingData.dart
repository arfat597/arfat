
import 'package:studentsystem/core/class/statusRequest.dart';

handlingData(response) {
  if (response is statusRequest) {
    return response;
  } else {
    return statusRequest.success;
  }
}

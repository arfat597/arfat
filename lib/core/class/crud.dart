import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:studentsystem/core/class/statusRequest.dart';
import 'package:studentsystem/core/function/Cheekintrnet.dart';


class Crud {
  Future<Either<statusRequest, Map>> postdata(String linkurl, Map data) async {
    if (await sheekIntrnet()) {
      var response = await http.post(Uri.parse(linkurl), body: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = jsonDecode(response.body);
        return Right(responsebody);
      } else {
        return const Left(statusRequest.serverfaliur);
      }
    } else {
      return const Left(statusRequest.ooflinefaliur);
    }
  }
}

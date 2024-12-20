import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ipodaily/dashboard_module/modal/drawer/common_details_model.dart';
import 'package:ipodaily/utilities/dio/api_end_points.dart';
import 'package:ipodaily/utilities/dio/api_request.dart';

class CommonDetailsController extends GetxController with StateMixin<CommonDetailsModel> {
  getCommonDetails({required String slug}) async {
    change(null, status: RxStatus.loading());
    final apiEndPoint = "${APIEndPoints.commonDetails}/$slug";
    debugPrint("---------- $apiEndPoint getCommonDetails Start ----------");
    try {
      final response = await getRequest(apiEndPoint: apiEndPoint);

      debugPrint("CommonDetailsController => getCommonDetails > Success  $response");

      final modal = CommonDetailsModel.fromJson(response.data);
      change(modal, status: RxStatus.success());
    } catch (error) {
      debugPrint("---------- $apiEndPoint getCommonDetails End With Error ----------");
      debugPrint("CommonDetailsController => getCommonDetails > Error $error ");
      change(null, status: RxStatus.error());
    } finally {
      debugPrint("---------- $apiEndPoint getCommonDetails End ----------");
    }
  }
}

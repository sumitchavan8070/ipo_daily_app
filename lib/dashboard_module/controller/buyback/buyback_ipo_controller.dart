import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ipodaily/dashboard_module/modal/buyback/buyback_ipo_model.dart';
import 'package:ipodaily/utilities/dio/api_end_points.dart';
import 'package:ipodaily/utilities/dio/api_request.dart';

class BuybackBoardIpoController extends GetxController with StateMixin<BuybackIpoModel> {
  getBuybackData() async {
    change(null, status: RxStatus.loading());
    const apiEndPoint = APIEndPoints.buyback;
    debugPrint("---------- $apiEndPoint getBuybackData Start ----------");
    try {
      final response = await getRequest(apiEndPoint: apiEndPoint);

      debugPrint("BuybackBoardIpoController => getBuybackData > Success  $response");

      if (response.statusCode != 200) {
        throw 'API ERROR ${response.statusCode} Message ${response.statusMessage}';
      }

      final modal = BuybackIpoModel.fromJson(response.data);
      change(modal, status: RxStatus.success());
    } catch (error) {
      debugPrint("---------- $apiEndPoint getBuybackData End With Error ----------");
      debugPrint("BuybackBoardIpoController => getBuybackData > Error $error ");
      change(null, status: RxStatus.error());
    } finally {
      debugPrint("---------- $apiEndPoint getBuybackData End ----------");
    }
  }
}

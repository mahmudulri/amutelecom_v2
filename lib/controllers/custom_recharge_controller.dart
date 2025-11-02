import 'dart:convert';

import 'package:amutelecom/routes/routes.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:amutelecom/controllers/custom_history_controller.dart';
import 'package:amutelecom/utils/api_endpoints.dart';

import 'result_controller.dart';

class CustomRechargeController extends GetxController {
  final ResultController resultController = Get.put(ResultController());
  TextEditingController numberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final box = GetStorage();

  TextEditingController pinController = TextEditingController();

  final customhistoryController = Get.find<CustomHistoryController>();

  RxBool isLoading = false.obs;

  RxBool loadsuccess = false.obs;
  RxBool showanimation = false.obs;
  Future<bool> placeOrder() async {
    try {
      isLoading.value = true;
      loadsuccess.value = false;

      var url = Uri.parse(
        "${ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.customrecharge}",
      );
      Map body = {
        'country_id': box.read("country_id"),
        'rechargeble_account': numberController.text,
        'amount': amountController.text,
      };

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read("userToken")}',
        },
      );

      final orderresults = jsonDecode(response.body);

      if (response.statusCode == 201 && orderresults["success"] == true) {
        resultController.updateResult(response.body);
        loadsuccess.value = true;
        isLoading.value = false;
        customhistoryController.finalList.clear();
        customhistoryController.initialpage = 1;
        customhistoryController.fetchHistory();
        Get.snackbar("", orderresults["message"]);
        clearInputs();
        // After loading ends
        Future.delayed(Duration(milliseconds: 300), () {
          Get.toNamed(customresultscreen);
        });

        return true;
      } else {
        handleFailure(orderresults["message"]);
        return false;
      }
    } catch (e) {
      handleFailure(e.toString());
      return false;
    }
  }

  void handleFailure(String message) {
    loadsuccess.value = false;

    isLoading.value = false;
    Get.snackbar(
      "Error",
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void clearInputs() {
    numberController.clear();
    amountController.clear();
  }
}

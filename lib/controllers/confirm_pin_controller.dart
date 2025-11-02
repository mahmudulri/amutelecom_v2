import 'dart:convert';
import 'package:amutelecom/controllers/history_controller.dart';
import 'package:amutelecom/controllers/result_controller.dart';
import 'package:amutelecom/global_controller/languages_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:amutelecom/utils/api_endpoints.dart';

class ConfirmPinController extends GetxController {
  TextEditingController numberController = TextEditingController();

  final ResultController resultController = Get.put(ResultController());
  final box = GetStorage();

  TextEditingController pinController = TextEditingController();
  final HistoryController historyController = Get.put(HistoryController());

  LanguagesController languagesController = Get.put(LanguagesController());

  RxBool isLoading = false.obs;
  RxBool placeingLoading = false.obs;

  RxBool loadsuccess = false.obs;

  Future<void> verify() async {
    try {
      isLoading.value = true;
      loadsuccess.value =
          false; // Start with false, only set to true if successful.

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      var url = Uri.parse(
        "${ApiEndPoints.baseUrl}confirm_pin?pin=${pinController.text}",
      );
      print(url.toString());

      http.Response response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
      );

      final results = jsonDecode(response.body);

      if (response.statusCode == 200 && results["success"] == true) {
        pinController.clear();
        loadsuccess.value =
            true; // Mark as successful only if status and success are correct

        // Proceed with placing the order
        placeOrder();
      } else {
        handleFailure(results["message"]);
      }
    } catch (e) {
      handleFailure(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void placeOrder() async {
    try {
      placeingLoading.value = true;
      var url = Uri.parse("${ApiEndPoints.baseUrl}place_order");
      Map body = {
        'bundle_id': box.read("bundleID"),
        'rechargeble_account': numberController.text,
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
        // print(response.body);

        resultController.updateResult(response.body);

        // var results = jsonDecode(response.body)["data"]["order"];

        loadsuccess.value = false;
        pinController.clear();
        numberController.clear();
        box.remove("bundleID");
        placeingLoading.value = false;
      } else {
        handleFailure(orderresults["message"]);
      }
    } catch (e) {
      handleFailure(e.toString());
    }
  }

  void handleFailure(String message) {
    loadsuccess.value = false;
    placeingLoading.value = false;
    Get.snackbar(
      "Error",
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    pinController.clear();
  }
}

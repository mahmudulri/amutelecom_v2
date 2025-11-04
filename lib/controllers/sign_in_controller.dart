import 'dart:convert';

import 'package:amutelecom/controllers/slider_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:amutelecom/controllers/country_list_controller.dart';
import 'package:amutelecom/utils/api_endpoints.dart';

class SignInController extends GetxController {
  final box = GetStorage();
  final SliderController sliderController = Get.put(SliderController());
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // final CountryListController countryListController =
  //     Get.put(CountryListController());

  RxBool isLoading = false.obs;
  RxBool loginsuccess = false.obs;

  Future<void> signIn() async {
    try {
      isLoading.value = true;
      loginsuccess.value = true; // Reset to false before starting login
      print(loginsuccess.value);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      var url = Uri.parse("${ApiEndPoints.baseUrl}login");

      print("API URL: $url");

      Map body = {
        'username': usernameController.text,
        'password': passwordController.text,
      };

      // Map body = {
      //   'username': "0774401234",
      //   'password': "12345678",
      // };
      // 0700036377

      // print("Request Body: $body");
      print(body.toString());

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: headers,
      );

      final results = jsonDecode(response.body);
      print(results);

      if (response.statusCode == 200) {
        box.write("userToken", results["data"]["api_token"]);
        box.write(
          "countryID",
          results["data"]["user_info"]["reseller"]["country_id"],
        );
        box.write(
          "currency_code",
          results["data"]["user_info"]["currency"]["code"],
        );
        box.write(
          "currencypreferenceID",
          results["data"]["user_info"]["currency_preference_id"],
        );
        box.write(
          "currencyName",
          results["data"]["user_info"]["currency"]["name"],
        );

        if (results["success"] == true) {
          usernameController.clear();
          passwordController.clear();
          loginsuccess.value = false;
          sliderController.fetchSliderData();
          print(loginsuccess.value);

          Fluttertoast.showToast(
            msg: results["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          // Fetch country data only if login is successful
        } else {
          Get.snackbar(
            results["message"],
            results["errors"],
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          results["message"],
          results["errors"],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error during sign in: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

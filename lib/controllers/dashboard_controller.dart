import 'dart:convert';
import 'package:amutelecom/utils/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/dashboard_data_model.dart';
import 'slider_controller.dart';

final box = GetStorage();

class DashboardController extends GetxController {
  var isLoading = false.obs;
  RxString message = "".obs;
  RxString myerror = "".obs;
  var alldashboardData = DashboardDataModel().obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  /// Fetch dashboard data and update state
  void fetchDashboardData() async {
    try {
      isLoading.value = true;
      final data = await fetchDashboard();
      alldashboardData.value = data;
      myerror.value = "";
      message.value = "";
    } catch (e) {
      print("Dashboard fetch error: $e");
      // error is already set in fetchDashboard
    } finally {
      isLoading.value = false;
    }
  }

  /// API call to get dashboard
  Future<DashboardDataModel> fetchDashboard() async {
    final url = Uri.parse(
      ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.dashboard,
    );
    print("Dashboard API URL: $url");

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
      );

      final results = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Success
        myerror.value = "";
        message.value = "";
        return DashboardDataModel.fromJson(results);
      } else if (response.statusCode == 403) {
        // Forbidden / Deactivated
        myerror.value = results["errors"] ?? "Deactivated";
        message.value = results["message"] ?? "Access forbidden";

        Fluttertoast.showToast(
          msg: message.value,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        throw Exception('Forbidden: ${message.value}');
      } else {
        throw Exception(
          'Failed to fetch dashboard. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("Dashboard API exception: $e");
      rethrow;
    }
  }
}

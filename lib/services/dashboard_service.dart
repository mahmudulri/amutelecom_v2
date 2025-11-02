import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/dashboard_data_model.dart';
import '../utils/api_endpoints.dart';

class DashboardApi {
  final box = GetStorage();

  Future<DashboardDataModel> fetchDashboard() async {
    final url =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.dashboard);
    print(url);

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${box.read("userToken")}',
      },
    );

    // Check if the response status code is 200 (OK)
    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);
      final dashboardModel = DashboardDataModel.fromJson(results);
      return dashboardModel;
    }
    // Handle 403 status code (Forbidden)
    else if (response.statusCode == 403) {
      // Decode the response body to extract the message
      final results = jsonDecode(response.body);

      // Show the toast with the message
      Fluttertoast.showToast(
        msg: results[
            "message"], // Assuming the "message" is in the response body
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Optionally, you can throw an exception or handle the 403 error in another way
      throw Exception('Forbidden: ${results["message"]}');
    }
    // Handle other status codes
    else {
      throw Exception(
          'Failed to fetch dashboard. Status code: ${response.statusCode}');
    }
  }
}

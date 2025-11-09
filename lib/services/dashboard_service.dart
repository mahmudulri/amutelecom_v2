import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../controllers/dashboard_controller.dart';
import '../models/dashboard_data_model.dart';
import '../utils/api_endpoints.dart';

final box = GetStorage();

class DashboardApi {
  final dashboardController = Get.find<DashboardController>();
}

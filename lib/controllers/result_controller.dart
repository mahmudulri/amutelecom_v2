import 'dart:convert';
import 'package:get/get.dart';
import '../models/result_model.dart'; // Ensure this points to your ResultModel

class ResultController extends GetxController {
  Rx<ResultModel?> resultModel = Rx<ResultModel?>(null);

  var isLoading = false.obs;

  void updateResult(String jsonResponse) {
    try {
      isLoading(true);
      var decodedJson = jsonDecode(jsonResponse);
      resultModel.value = ResultModel.fromJson(decodedJson);
      isLoading(false);
    } catch (e) {
      print("Error parsing JSON: $e");
    }
  }
}

import 'dart:convert';
import 'package:amutelecom/models/custom_result_model.dart';
import 'package:get/get.dart';

class CustomResultController extends GetxController {
  Rx<CustomResultModel?> resultModel = Rx<CustomResultModel?>(null);

  var isLoading = false.obs;

  void updateResult(String jsonResponse) {
    try {
      isLoading(true);
      var decodedJson = jsonDecode(jsonResponse);
      resultModel.value = CustomResultModel.fromJson(decodedJson);
      isLoading(false);
    } catch (e) {
      print("Error parsing JSON: $e");
    }
  }
}

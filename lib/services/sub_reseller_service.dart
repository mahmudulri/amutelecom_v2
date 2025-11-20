import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/dashboard_data_model.dart';
import '../models/sub_reseller_model.dart';
import '../utils/api_endpoints.dart';

class SubResellerApi {
  final box = GetStorage();
  Future<SubResellerModel> fetchSubReseller(int pageNo) async {
    final url = Uri.parse(
      "${ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.subreseller}?page=${pageNo}&search_target=${box.read("search_target")}",
    );

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final subresellerModel = SubResellerModel.fromJson(
        json.decode(response.body),
      );

      return subresellerModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

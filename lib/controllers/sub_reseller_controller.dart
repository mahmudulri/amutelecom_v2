import 'package:get/get.dart';
import 'package:amutelecom/services/dashboard_service.dart';
import 'package:amutelecom/services/sub_reseller_service.dart';

import '../models/dashboard_data_model.dart';
import '../models/sub_reseller_model.dart';

class SubresellerController extends GetxController {
  RxList<Reseller> finalList = <Reseller>[].obs;

  int initialpage = 2;

  var isLoading = false.obs;

  var allsubresellerData = SubResellerModel().obs;

  void fetchSubReseller() async {
    try {
      isLoading(true);
      await SubResellerApi().fetchSubReseller(initialpage).then((value) {
        allsubresellerData.value = value;

        if (allsubresellerData.value.data != null) {
          finalList.addAll(allsubresellerData.value.data!.resellers);
        }

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

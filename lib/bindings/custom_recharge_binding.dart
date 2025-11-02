import 'package:get/get.dart';
import 'package:amutelecom/controllers/custom_history_controller.dart';
import 'package:amutelecom/controllers/custom_recharge_controller.dart';
import 'package:amutelecom/controllers/history_controller.dart';

class CustomRechargeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomRechargeController>(() => CustomRechargeController());
    Get.lazyPut<HistoryController>(() => HistoryController());
    Get.lazyPut<CustomHistoryController>(() => CustomHistoryController());
  }
}

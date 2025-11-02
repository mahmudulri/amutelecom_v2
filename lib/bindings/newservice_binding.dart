import 'package:amutelecom/controllers/bundles_controller.dart';
import 'package:amutelecom/controllers/categories_list_controller.dart';
import 'package:amutelecom/controllers/confirm_pin_controller.dart';

import 'package:amutelecom/controllers/service_controller.dart';
import 'package:get/get.dart';

class NewServiceBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BundleController>(() => BundleController());
    Get.lazyPut<CategorisListController>(() => CategorisListController());
    Get.lazyPut<ServiceController>(() => ServiceController());
    // Get.lazyPut<ReserveDigitController>(() => ReserveDigitController());
    Get.lazyPut<ConfirmPinController>(() => ConfirmPinController());
  }
}

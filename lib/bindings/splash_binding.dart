import 'package:amutelecom/controllers/history_controller.dart';
import 'package:amutelecom/controllers/iso_code_controller.dart';
import 'package:amutelecom/controllers/language_controller.dart';
import 'package:amutelecom/controllers/slider_controller.dart';
import 'package:get/get.dart';

import '../controllers/country_list_controller.dart';
import '../controllers/dashboard_controller.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<LanguageController>(() => LanguageController());
    Get.lazyPut<IscoCodeController>(() => IscoCodeController());
    Get.lazyPut<SliderController>(() => SliderController());
    Get.lazyPut<HistoryController>(() => HistoryController());
    Get.lazyPut<CountryListController>(() => CountryListController());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}

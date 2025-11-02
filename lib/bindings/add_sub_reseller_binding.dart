import 'package:amutelecom/controllers/add_sub_reseller_controller.dart';
import 'package:amutelecom/controllers/currency_controller.dart';
import 'package:amutelecom/controllers/district_controller.dart';
import 'package:amutelecom/controllers/province_controller.dart';
import 'package:get/get.dart';

class AddSubResellerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProvinceController>(() => ProvinceController());

    Get.lazyPut<CurrencyListController>(() => CurrencyListController());

    Get.lazyPut<DistrictController>(() => DistrictController());

    Get.lazyPut<AddSubResellerController>(() => AddSubResellerController());
  }
}

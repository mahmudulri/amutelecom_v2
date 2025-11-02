import 'package:amutelecom/controllers/country_list_controller.dart';
import 'package:amutelecom/controllers/history_controller.dart';
import 'package:amutelecom/controllers/sign_in_controller.dart';
import 'package:amutelecom/controllers/transaction_controller.dart';
import 'package:get/get.dart';

class SignInBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController());
    Get.lazyPut<HistoryController>(() => HistoryController());
    Get.lazyPut<CountryListController>(() => CountryListController());
  }
}

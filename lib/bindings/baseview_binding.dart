import 'package:amutelecom/controllers/bundles_controller.dart';
import 'package:amutelecom/controllers/categories_list_controller.dart';
import 'package:amutelecom/controllers/change_status_controller.dart';
import 'package:amutelecom/controllers/country_list_controller.dart';
import 'package:amutelecom/controllers/custom_history_controller.dart';
import 'package:amutelecom/controllers/dashboard_controller.dart';
import 'package:amutelecom/controllers/delete_sub_reseller.dart';
import 'package:amutelecom/controllers/history_controller.dart';
import 'package:amutelecom/controllers/order_list_controller.dart';
import 'package:amutelecom/controllers/service_controller.dart';
import 'package:amutelecom/controllers/sign_in_controller.dart';
import 'package:amutelecom/controllers/sub_reseller_controller.dart';
import 'package:amutelecom/controllers/subreseller_details_controller.dart';
import 'package:amutelecom/controllers/transaction_controller.dart';
import 'package:amutelecom/global_controller/languages_controller.dart';
import 'package:get/get.dart';

class BaseViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<OrderlistController>(() => OrderlistController());
    Get.lazyPut<TransactionController>(() => TransactionController());
    Get.lazyPut<HistoryController>(() => HistoryController());
    Get.lazyPut<CountryListController>(() => CountryListController());
    Get.lazyPut<SignInController>(() => SignInController());
    Get.lazyPut<ServiceController>(() => ServiceController());
    Get.lazyPut<BundleController>(() => BundleController());
    Get.lazyPut<LanguagesController>(() => LanguagesController());

    Get.lazyPut<SubresellerController>(() => SubresellerController());
    Get.lazyPut<SubresellerDetailsController>(
      () => SubresellerDetailsController(),
    );

    Get.lazyPut<DeleteSubResellerController>(
      () => DeleteSubResellerController(),
    );
    Get.lazyPut<ChangeStatusController>(() => ChangeStatusController());

    Get.lazyPut<CategorisListController>(() => CategorisListController());
    Get.lazyPut<CustomHistoryController>(() => CustomHistoryController());
  }
}

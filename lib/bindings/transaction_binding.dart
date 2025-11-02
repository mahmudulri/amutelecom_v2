import 'package:amutelecom/controllers/transaction_controller.dart';
import 'package:get/get.dart';

class TransactionBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionController>(() => TransactionController());
  }
}

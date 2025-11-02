import 'package:amutelecom/controllers/order_list_controller.dart';
import 'package:get/get.dart';

class OrdersBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderlistController>(() => OrderlistController());
  }
}

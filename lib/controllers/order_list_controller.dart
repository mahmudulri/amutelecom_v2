import 'package:get/get.dart';
import 'package:amutelecom/models/orders_list_model.dart';

import 'package:amutelecom/services/order_list_service.dart';

class OrderlistController extends GetxController {
  RxList<Order> finalList = <Order>[].obs;

  RxBool isLoading = false.obs; // First page load
  RxBool isFetchingMore = false.obs; // Pagination load
  RxBool isLastPage = false.obs; // No more pages

  int currentPage = 1;
  int totalPages = 1;

  Rx<OrderListModel> allorderlist = OrderListModel().obs;

  /// ********** Fetch First Page **********
  Future<void> fetchOrderlistdata() async {
    try {
      isLoading(true);

      currentPage = 1;
      isLastPage(false);
      finalList.clear();

      final value = await OrderListApi().fetchorderList(currentPage);

      allorderlist.value = value;

      // Total pages from API
      totalPages = value.payload?.pagination.totalPages ?? 1;

      if (value.data != null) {
        finalList.addAll(value.data!.orders);
      }
    } catch (e) {
      print("ERROR: $e");
    } finally {
      isLoading(false);
    }
  }

  /// ********** Pagination: Fetch Next Page **********
  Future<void> fetchMore() async {
    if (isFetchingMore.value || isLastPage.value) return;

    if (currentPage >= totalPages) {
      isLastPage(true);
      print("End...............................End");
      return;
    }

    try {
      isFetchingMore(true);

      currentPage++;

      print("Loading Page: $currentPage");

      final value = await OrderListApi().fetchorderList(currentPage);

      if (value.data != null) {
        finalList.addAll(value.data!.orders);
      }

      if (currentPage >= totalPages) {
        isLastPage(true);
        print("End...............................End");
      }
    } catch (e) {
      print("ERROR: $e");
    } finally {
      isFetchingMore(false);
    }
  }
}

import 'package:get/get.dart';
import 'package:amutelecom/models/categories_service_model.dart';
import 'package:amutelecom/services/categoris_service_list.dart';
import 'package:amutelecom/services/country_list_service.dart';

import '../models/country_list_model.dart';

class CategorisListController extends GetxController {
  @override
  void onInit() {
    fetchcategories();
    super.onInit();
  }

  var isLoading = false.obs;

  var allcategorieslist = Rx<NewServiceCatModel?>(null);

  void fetchcategories() async {
    try {
      isLoading(true);
      await CategoriesListApi().fetchcategoriesList().then((value) {
        allcategorieslist.value = value;
        // print(allcategorieslist.toJson());

        // print(allcategorieslist.toJson());
        // print("before" + isLoading.toString());

        isLoading(false);
        // print("after" + isLoading.toString());
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

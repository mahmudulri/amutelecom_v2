import 'package:get/get.dart';
import 'package:amutelecom/services/country_list_service.dart';
import 'package:get_storage/get_storage.dart';

import '../models/country_list_model.dart';

class CountryListController extends GetxController {
  final box = GetStorage();
  @override
  void onInit() {
    fetchCountryData();
    super.onInit();
  }

  var isLoading = false.obs;
  var finalCountryList = [];

  var allcountryListData = CountryListModel().obs;

  void fetchCountryData() async {
    try {
      isLoading(true);
      await CountryListApi().fetchCountryList().then((value) {
        allcountryListData.value = value;
        // print(allcountryListData.toJson()['data']['vehicles']);
        finalCountryList = allcountryListData.toJson()['data']['countries'];
        // print(finalCountryList);

        // print(allcountryListData.toJson());
        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }

  void printAfghanistanDetails() {
    if (finalCountryList.isNotEmpty) {
      var afghanistan = finalCountryList.firstWhere(
        (country) => country['country_name'] == 'Afghanistan',
        orElse: () => null, // Returns null if not found
      );

      if (afghanistan != null) {
        print(
          "ID: ${afghanistan['id']}, Phone Number Length: ${afghanistan['phone_number_length']}",
        );

        box.write("country_id", "${afghanistan['id']}");
        box.write("maxlength", "${afghanistan['phone_number_length']}");
      } else {
        print("Afghanistan not found in the list.");
      }
    } else {
      print("Country list is empty.");
    }
  }
}

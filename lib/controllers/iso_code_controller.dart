import 'package:get/get.dart';
import 'package:amutelecom/models/bundle_model.dart';
import 'package:amutelecom/models/isocode_model.dart';
import 'package:amutelecom/models/language_model.dart';
import 'package:amutelecom/services/isocode_service.dart';
import 'package:amutelecom/services/language_service.dart';

class IscoCodeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  var isLoading = false.obs;

  var allisoCodeData = IsoCodeModel().obs;

  void fetchisoCode() async {
    try {
      isLoading(true);
      await IsoCodeApi().fetchIsoCode().then((value) {
        allisoCodeData.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

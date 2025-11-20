import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  RxBool hasinternet = true.obs;

  @override
  void onInit() {
    super.onInit();

    _connectivity.onConnectivityChanged.listen((connectivityResults) {
      _updateConnectionStatus(connectivityResults);
    });
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResults) {
    if (connectivityResults.contains(ConnectivityResult.none)) {
      hasinternet.value = false;

      // If no dialog is open → then open dialog
      if (Get.isDialogOpen != true) {
        Get.dialog(
          AlertDialog(
            title: const Text('No Internet Connection'),
            content: const Text('Please connect to the internet.'),
          ),
          barrierDismissible: false,
        );
      }
    } else {
      hasinternet.value = true;

      // Close dialog IF it is open
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }
}

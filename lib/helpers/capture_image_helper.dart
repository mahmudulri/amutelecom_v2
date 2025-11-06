// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:get/get.dart';
// import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
// import 'package:permission_handler/permission_handler.dart';

// import '../global_controller/languages_controller.dart';

// GlobalKey catpureKey = GlobalKey();

// LanguagesController languageController = Get.put(LanguagesController());

// Future<void> capturePng() async {
//   try {
//     bool hasPermission = await _handlePermission();

//     if (!hasPermission) {
//       Get.snackbar(
//         languageController.tr("PERMISSION_DENIED"),
//         languageController.tr("STORAGE_PERMISSION_IS_REQUIRED"),
//       );
//       return;
//     }

//     RenderRepaintBoundary? boundary =
//         catpureKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

//     if (boundary == null) {
//       print("❌ No boundary found.");
//       return;
//     }

//     ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//     ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

//     if (byteData == null) {
//       print("❌ Failed to convert image to bytes.");
//       return;
//     }

//     Uint8List pngBytes = byteData.buffer.asUint8List();

//     final result = await ImageGallerySaverPlus.saveImage(
//       pngBytes,
//       quality: 100,
//       name: "screenshot_${DateTime.now().millisecondsSinceEpoch}",
//     );

//     if (result['isSuccess'] == true) {
//       Get.snackbar(
//         languageController.tr("SUCCESS"),
//         languageController.tr("IMAGE_SAVED_TO_GALLERY"),
//       );
//     } else {
//       Get.snackbar("FAILED", "Could not save image.");
//     }
//   } catch (e) {
//     print("⚠️ Error while capturing: $e");

//     Get.snackbar(
//       languageController.tr("ERROR"),
//       languageController.tr("FAILED_TO_CAPTURE_IMAGE"),
//     );
//   }
// }

// Future<bool> _handlePermission() async {
//   if (await Permission.storage.isGranted) return true;

//   if (await Permission.photos.request().isGranted) return true;

//   final status = await Permission.storage.request();
//   return status.isGranted;
// }

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

import '../global_controller/languages_controller.dart';

GlobalKey catpureKey = GlobalKey();
LanguagesController languageController = Get.put(LanguagesController());

Future<void> capturePng() async {
  try {
    // 🔹 Capture widget
    RenderRepaintBoundary? boundary =
        catpureKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) {
      debugPrint("❌ No boundary found.");
      return;
    }

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      debugPrint("❌ Failed to convert image to bytes.");
      return;
    }

    Uint8List pngBytes = byteData.buffer.asUint8List();

    // 🔹 Save to gallery (Scoped Storage handled internally)
    final result = await ImageGallerySaverPlus.saveImage(
      pngBytes,
      quality: 100,
      name: "screenshot_${DateTime.now().millisecondsSinceEpoch}",
    );

    if (result['isSuccess'] == true) {
      Get.snackbar(
        languageController.tr("SUCCESS"),
        languageController.tr("IMAGE_SAVED_TO_GALLERY"),
      );
    } else {
      Get.snackbar("FAILED", "Could not save image.");
    }
  } catch (e) {
    debugPrint("⚠️ Error while capturing: $e");
    Get.snackbar(
      languageController.tr("ERROR"),
      languageController.tr("FAILED_TO_CAPTURE_IMAGE"),
    );
  }
}

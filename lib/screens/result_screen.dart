import 'dart:io';

import 'package:amutelecom/controllers/country_list_controller.dart';
import 'package:amutelecom/controllers/history_controller.dart';
import 'package:amutelecom/controllers/time_zone_controller.dart';
import 'package:amutelecom/global_controller/languages_controller.dart';
import 'package:amutelecom/pages/orders.dart';
import 'package:amutelecom/routes/routes.dart';
import 'package:amutelecom/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../controllers/result_controller.dart';
import 'dart:ui' as ui;

import '../helpers/capture_image_helper.dart';
import '../helpers/share_image_helper.dart';

class ResultScreen extends StatefulWidget {
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ResultController resultController = Get.find<ResultController>();

  final HistoryController historyController = Get.put(HistoryController());

  final countryListController = Get.find<CountryListController>();

  LanguagesController languagesController = Get.put(LanguagesController());

  final box = GetStorage();
  final TimeZoneController timeZoneController = Get.put(TimeZoneController());
  Text convertToLocalTime(String utcTimeString) {
    String localTimeString;
    try {
      // Parse the UTC time
      DateTime utcTime = DateTime.parse(utcTimeString);

      // Calculate the offset duration
      Duration offset = Duration(
        hours: int.parse(timeZoneController.hour),
        minutes: int.parse(timeZoneController.minute),
      );

      // Apply the offset (subtracting for negative)

      if (timeZoneController.sign == "+") {
        DateTime localTime = utcTime.add(offset);
        String formattedTime = DateFormat(
          'yyyy-MM-dd hh:mm:ss a',
          'en_US',
        ).format(localTime);
        localTimeString = '$formattedTime';
      } else {
        DateTime localTime = utcTime.subtract(offset);
        String formattedTime = DateFormat(
          'yyyy-MM-dd hh:mm:ss a',
          'en_US',
        ).format(localTime);

        localTimeString = '$formattedTime';
      }
    } catch (e) {
      localTimeString = '';
    }
    return Text(
      localTimeString,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          if (resultController.resultModel.value == null) {
            return Center(child: CircularProgressIndicator(color: Colors.grey));
          }

          var order = resultController.resultModel.value!.data?.order;
          if (order == null) {
            return Center(
              child: Text(languagesController.tr("ORDER_DATA_IS_MISSING")),
            );
          }

          return Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RepaintBoundary(
                    key: catpureKey,
                    child: RepaintBoundary(
                      key: shareKey,
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: Column(
                            children: [
                              // SizedBox(
                              //   height: 30,
                              // ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              height: 55,
                                              width: 55,
                                              decoration: BoxDecoration(
                                                // border: Border.all(
                                                //   width: 2,
                                                //   color: Colors.black.withOpacity(0.2),
                                                // ),
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage(
                                                    "assets/icons/logo.png",
                                                  ),
                                                ),
                                                // color: Colors.red,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              "Amu Telecom",
                                              style: GoogleFonts.aBeeZee(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  convertToLocalTime(
                                    order.createdAt.toString(),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      languagesController.tr("SUCCESS_TITLE"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w400,
                                        fontSize: screenHeight * 0.020,
                                      ),
                                    ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text(
                                    //       languagesController
                                    //           .tr("ORDER_STATUS"),
                                    //       style: TextStyle(
                                    //         color: Colors.green,
                                    //         fontSize: 17,
                                    //       ),
                                    //     ),
                                    //     Text(
                                    //       order.status.toString() == "0"
                                    //           ? languagesController
                                    //               .tr("PENDING")
                                    //           : order.status.toString() == "1"
                                    //               ? languagesController
                                    //                   .tr("CONFIRMED")
                                    //               : languagesController
                                    //                   .tr("REJECTED"),
                                    //       style: TextStyle(
                                    //         fontSize: 17,
                                    //         fontWeight: FontWeight.w400,
                                    //         color: order.status.toString() ==
                                    //                 "0"
                                    //             ? Colors.grey
                                    //             : order.status.toString() == "1"
                                    //                 ? Colors.green
                                    //                 : Colors.red,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    SizedBox(height: 5),
                                    // Visibility(
                                    //   visible: order.status.toString() == "2",
                                    //   child: Text(
                                    //     order.rejectReason.toString(),
                                    //     style: TextStyle(
                                    //       color: Colors.red,
                                    //     ),
                                    //   ),
                                    // ),
                                    SizedBox(height: 3),
                                    Container(
                                      height: 1,
                                      color: AppColors.defaultColor.withOpacity(
                                        0.5,
                                      ),
                                      width: screenWidth,
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      // color: Colors.red,
                                      height: 30,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            languagesController.tr(
                                              "NETWORK_TYPE",
                                            ),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            order
                                                .bundle!
                                                .service!
                                                .company!
                                                .companyName
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    dotline(),
                                    Visibility(
                                      visible:
                                          order.bundle!.bundleTitle
                                              .toString() !=
                                          "",
                                      child: Container(
                                        // color: Colors.cyan,
                                        height: 30,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              languagesController.tr(
                                                "BUNDLE_TYPE",
                                              ),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              order.bundle!.bundleTitle
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    dotline(),
                                    Container(
                                      // color: Colors.red,
                                      height: 30,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            languagesController.tr(
                                              "PHONE_NUMBER",
                                            ),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            order.rechargebleAccount.toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    dotline(),
                                    Visibility(
                                      visible:
                                          order.bundle!.validityType
                                              .toString() !=
                                          "",
                                      child: Container(
                                        // color: Colors.yellow,
                                        height: 30,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              languagesController.tr(
                                                "VALIDITY_TYPE",
                                              ),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              order.bundle!.validityType
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // dotline(),
                                    // Container(
                                    //   // color: Colors.cyanAccent,
                                    //   height: 30,
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.spaceBetween,
                                    //     children: [
                                    //       Text(
                                    //         languagesController
                                    //             .tr("SELLING_PRICE"),
                                    //         style: TextStyle(
                                    //           fontSize: 14,
                                    //           color: Colors.black,
                                    //         ),
                                    //       ),
                                    //       Row(
                                    //         children: [
                                    //           Text(
                                    //             box.read("currency_code"),
                                    //             style: TextStyle(
                                    //               fontSize: 14,
                                    //               color: Colors.black,
                                    //             ),
                                    //           ),
                                    //           SizedBox(
                                    //             width: 8,
                                    //           ),
                                    //           Text(
                                    //             NumberFormat.currency(
                                    //               locale: 'en_US',
                                    //               symbol: '',
                                    //               decimalDigits: 2,
                                    //             ).format(
                                    //               double.parse(
                                    //                 order.bundle!.sellingPrice
                                    //                     .toString(),
                                    //               ),
                                    //             ),
                                    //             style: TextStyle(
                                    //               color: Colors.black,
                                    //               fontSize: 14,
                                    //               fontWeight: FontWeight.w600,
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    dotline(),
                                    Container(
                                      // color: Colors.blue,
                                      height: 30,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            languagesController.tr("ORDER_ID"),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            "AT#- " + order.id.toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      height: 1,
                                      color: AppColors.defaultColor.withOpacity(
                                        0.5,
                                      ),
                                      width: screenWidth,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    order.reseller!.contactName.toString(),
                                    style: GoogleFonts.oswald(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    order.reseller!.phone.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                      order
                                          .bundle!
                                          .service!
                                          .company!
                                          .companyLogo
                                          .toString(),
                                    ),
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  color: AppColors.defaultColor.withOpacity(
                                    0.1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 7,
                                  ),
                                  child: Center(
                                    child: Text(
                                      languagesController.tr(
                                        "BEST_TELECOM_AND_SOCIAL_PACKAGES_PROVIDER",
                                      ),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 45,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: AppColors.defaultColor.withOpacity(0.1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () async {
                              captureImageFromWidgetAsFile(shareKey);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.defaultColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    child: Center(
                                      child: Text(
                                        languagesController.tr("SHARE"),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () async {
                              capturePng();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.defaultColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    child: Center(
                                      child: Text(
                                        languagesController.tr("SAVE_AS_IMAGE"),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              box.write("country_id", "2");
                              box.write("maxlength", "10");
                              historyController.finalList.clear();
                              historyController.initialpage = 1;
                              historyController.fetchHistory();
                              // countryListController.fetchCountryData();

                              Get.toNamed(newbasescreen);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.defaultColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    child: Center(
                                      child: Text(
                                        languagesController.tr("CLOSE"),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

import 'package:amutelecom/controllers/categories_list_controller.dart';
import 'package:amutelecom/routes/routes.dart';
import 'package:amutelecom/widgets/number_textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:amutelecom/controllers/bundles_controller.dart';
import 'package:amutelecom/controllers/service_controller.dart';
import 'package:amutelecom/helpers/price.dart';

import '../controllers/confirm_pin_controller.dart';

import '../global_controller/languages_controller.dart';
import '../utils/colors.dart';

class RechargeScreen extends StatefulWidget {
  RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  int selectedIndex = -1;
  int duration_selectedIndex = 0;

  final categorisListController = Get.find<CategorisListController>();

  LanguagesController languagesController = Get.put(LanguagesController());

  List mycatlist = [];
  int? selectedId;

  List<Map<String, String>> duration = [];
  void initializeDuration() {
    duration = [
      {"Name": languagesController.tr("All"), "Value": ""},
      {"Name": languagesController.tr("UNLIMITED"), "Value": "unlimited"},
      {"Name": languagesController.tr("MONTHLY"), "Value": "monthly"},
      {"Name": languagesController.tr("WEEKLY"), "Value": "weekly"},
      {"Name": languagesController.tr("DAILY"), "Value": "daily"},
      {"Name": languagesController.tr("HOURLY"), "Value": "hourly"},
      {"Name": languagesController.tr("NIGHTLY"), "Value": "nightly"},
    ];
  }

  final ServiceController serviceController = Get.put(ServiceController());
  final BundleController bundleController = Get.put(BundleController());
  final ConfirmPinController confirmPinController = Get.put(
    ConfirmPinController(),
  );

  final box = GetStorage();

  TextEditingController searchController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  String search = "";
  String inputNumber = "";

  @override
  void initState() {
    super.initState();
    // serviceController.fetchservices();
    // bundleController.fetchallbundles();
    confirmPinController.numberController.addListener(_onTextChanged);
    initializeDuration();
    scrollController.addListener(refresh);
    // Use addPostFrameCallback to ensure this runs after the initial build
    // WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  void _onTextChanged() {
    if (!mounted) return;

    setState(() {
      inputNumber = confirmPinController.numberController.text;

      // Print debug information
      print("Input Number: $inputNumber");

      if (inputNumber.isEmpty) {
        box.write("company_id", "");
        bundleController.initialpage = 1;
        bundleController.finalList.clear();
        bundleController.fetchallbundles();
        // Handle case where text field is cleared
        print("Text field is empty. Showing all services.");

        // Clear the company_id from the box

        // Reset bundleController and fetch all bundles
      } else if (inputNumber.length == 3 || inputNumber.length == 4) {
        final services = serviceController.allserviceslist.value.data!.services;

        // Print number of services for debugging
        print("Number of services: ${services.length}");

        bool matchFound = false;

        for (var service in services) {
          for (var code in service.company!.companycodes!) {
            // Print reservedDigit for debugging
            print("Checking reservedDigit: ${code.reservedDigit}");

            if (code.reservedDigit == inputNumber) {
              box.write("company_id", service.companyId);
              bundleController.initialpage = 1;
              bundleController.finalList.clear();
              setState(() {
                bundleController.fetchallbundles();
              });

              print("Matched company_id: ${service.companyId}");
              matchFound = true;
              break; // Exit the inner loop
            }
          }
          if (matchFound) break; // Exit the outer loop
        }

        if (!matchFound) {
          print("No match found for input number: $inputNumber");
        }
      }
    });
  }

  @override
  void dispose() {
    confirmPinController.numberController.removeListener(_onTextChanged);

    super.dispose();
  }

  Future<void> refresh() async {
    final int totalPages =
        bundleController.allbundleslist.value.payload?.pagination.totalPages ??
        0;
    final int currentPage = bundleController.initialpage;

    // Prevent loading more pages if we've reached the last page
    if (currentPage >= totalPages) {
      print(
        "End..........................................End.....................",
      );
      return;
    }

    // Check if the scroll position is at the bottom
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      bundleController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (bundleController.initialpage <= totalPages) {
        print("Load More...................");
        bundleController.fetchallbundles();
      } else {
        bundleController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        confirmPinController.numberController.clear();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () {
                confirmPinController.numberController.clear();
                Get.back();
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.black),
            ),
            elevation: 0.0,
            centerTitle: true,
            title: GestureDetector(
              onTap: () {
                // serviceController.fetchservices();
                print(box.read("country_id"));
              },
              child: Text(
                languagesController.tr("RECHARGE"),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          body: Container(
            height: screenHeight,
            width: screenWidth,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.cyan,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13, vertical: 2),
                    child: Column(
                      children: [
                        CustomTextField(
                          confirmPinController:
                              confirmPinController.numberController,
                          // numberLength: widget.numberlength,
                          languageData: "07xxxxxxxxx",
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 80,
                          color: Colors.transparent,
                          width: screenWidth,
                          child: Obx(() {
                            // Check if the allserviceslist is not null and contains data
                            final services =
                                serviceController
                                    .allserviceslist
                                    .value
                                    .data
                                    ?.services ??
                                [];

                            // Show all services if input is empty, otherwise filter
                            final filteredServices = inputNumber.isEmpty
                                ? services
                                : services.where((service) {
                                    return service.company?.companycodes?.any((
                                          code,
                                        ) {
                                          final reservedDigit =
                                              code.reservedDigit ?? '';
                                          return inputNumber.startsWith(
                                            reservedDigit,
                                          );
                                        }) ??
                                        false;
                                  }).toList();

                            return serviceController.isLoading.value == false
                                ? Center(
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) {
                                        return SizedBox(width: 5);
                                      },
                                      scrollDirection: Axis.horizontal,
                                      itemCount: filteredServices.length,
                                      itemBuilder: (context, index) {
                                        final data = filteredServices[index];

                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              bundleController.initialpage = 1;
                                              bundleController.finalList
                                                  .clear();
                                              selectedIndex = index;
                                              box.write(
                                                "company_id",
                                                data.companyId,
                                              );
                                              bundleController
                                                  .fetchallbundles();
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 50,
                                                width: 65,
                                                decoration: BoxDecoration(
                                                  color: selectedIndex == index
                                                      ? Color(0xff34495e)
                                                      : Colors.grey.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                    vertical: 5,
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        data
                                                            .company
                                                            ?.companyLogo ??
                                                        '',
                                                    placeholder: (context, url) {
                                                      print(
                                                        'Loading image: $url',
                                                      );
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      );
                                                    },
                                                    errorWidget:
                                                        (context, url, error) {
                                                          print(
                                                            'Error loading image: $url, error: $error',
                                                          );
                                                          return Icon(
                                                            Icons.error,
                                                          );
                                                        },
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                data.company!.companyName
                                                    .toString(),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.grey,
                                      strokeWidth: 1.0,
                                    ),
                                  );
                          }),
                        ),
                        SizedBox(height: 8),
                        // Container(
                        //   height: 35,
                        //   color: Colors.white,
                        //   child: ListView.separated(
                        //     physics: BouncingScrollPhysics(),
                        //     separatorBuilder: (context, index) {
                        //       return SizedBox(
                        //         width: 2,
                        //       );
                        //     },
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount: categorisListController.allcategorieslist
                        //         .value!.data!.servicecategories!.length,
                        //     itemBuilder: (context, index) {
                        //       final data = categorisListController
                        //           .allcategorieslist
                        //           .value!
                        //           .data!
                        //           .servicecategories![index];
                        //       final storedId = box.read("service_category_id");
                        //       return GestureDetector(
                        //         onTap: () {
                        //           setState(() {
                        //             selectedId =
                        //                 data.id; // Update the selected ID
                        //             box.write("service_category_id", data.id);
                        //             bundleController.finalList.clear();
                        //             bundleController.initialpage = 1;
                        //             bundleController.fetchallbundles();
                        //             serviceController.fetchservices();
                        //           });
                        //         },
                        //         child: Container(
                        //           decoration: BoxDecoration(
                        //             color: (selectedId == data.id ||
                        //                     storedId == data.id)
                        //                 ? Colors.green.shade300
                        //                 : Colors.white,
                        //             borderRadius: BorderRadius.circular(8),
                        //           ),
                        //           child: Padding(
                        //             padding: EdgeInsets.all(5.0),
                        //             child: Center(
                        //               child: Text(
                        //                 data.categoryName.toString(),
                        //                 style: TextStyle(
                        //                   color: (selectedId == data.id ||
                        //                           storedId == data.id)
                        //                       ? Colors.white
                        //                       : Colors.black,
                        //                   fontWeight: FontWeight.w600,
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                        SizedBox(height: 8),
                        Container(
                          // color: Colors.purple,
                          height: 30,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: duration.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    duration_selectedIndex = index;
                                    box.write(
                                      "validity_type",
                                      duration[index]["Value"],
                                    );
                                    bundleController.initialpage = 1;
                                    bundleController.finalList.clear();
                                    bundleController.fetchallbundles();
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: duration_selectedIndex == index
                                        ? Colors.green
                                        : Colors.white,
                                  ),
                                  height: 30,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 2,
                                      ),
                                      child: Text(
                                        duration[index]["Name"]!,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: duration_selectedIndex == index
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(13.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  height: 50,
                                  width: screenWidth,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                    ),
                                    child: SizedBox(
                                      child: TextField(
                                        onChanged: (value) {
                                          bundleController.finalList.clear();
                                          bundleController.initialpage = 1;
                                          box.write(
                                            "search_tag",
                                            value.toString(),
                                          );
                                          bundleController.fetchallbundles();
                                          print(value.toString());
                                        },
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: languagesController.tr(
                                            "SEARCH",
                                          ),
                                          hintStyle: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                height: 45,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Obx(
                            () => bundleController.isLoading.value == false
                                ? Container(
                                    child:
                                        bundleController
                                            .allbundleslist
                                            .value
                                            .data!
                                            .bundles!
                                            .isNotEmpty
                                        ? SizedBox()
                                        : Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/icons/empty.png",
                                                  height: 80,
                                                ),
                                                Text(
                                                  languagesController.tr(
                                                    "NO_DATA_FOUND",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  )
                                : SizedBox(),
                          ),
                          Expanded(
                            child: Obx(
                              () =>
                                  bundleController.isLoading.value == false &&
                                      bundleController.finalList.isNotEmpty
                                  ? RefreshIndicator(
                                      onRefresh: refresh,
                                      child: ListView.separated(
                                        shrinkWrap: false,
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        controller: scrollController,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(height: 5);
                                        },
                                        itemCount:
                                            bundleController.finalList.length,
                                        itemBuilder: (context, index) {
                                          final data =
                                              bundleController.finalList[index];
                                          return GestureDetector(
                                            onTap: () {
                                              if (confirmPinController
                                                  .numberController
                                                  .text
                                                  .isEmpty) {
                                                Fluttertoast.showToast(
                                                  msg: languagesController.tr(
                                                    "ENTER_NUMBER",
                                                  ),
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.black,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              } else {
                                                if (box.read("permission") ==
                                                        "no" ||
                                                    confirmPinController
                                                            .numberController
                                                            .text
                                                            .length
                                                            .toString() !=
                                                        box
                                                            .read("maxlength")
                                                            .toString()) {
                                                  Fluttertoast.showToast(
                                                    msg: languagesController.tr(
                                                      "ENTER_CORRECT_NUMBER",
                                                    ),
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.black,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                  // Stop further execution if permission is "no"
                                                } else {
                                                  box.write(
                                                    "bundleID",
                                                    data.id.toString(),
                                                  );

                                                  Get.toNamed(confirmpinscreen);
                                                }
                                              }
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                top: 5,
                                                left: 2,
                                                right: 2,
                                              ),
                                              height: 60,
                                              width: screenWidth,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 2,
                                                    offset: Offset(0, 0),
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    bottom: 0,
                                                    top: 0,
                                                    left: 10,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data.bundleTitle
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 13,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          data.validityType
                                                                      .toString() ==
                                                                  "unlimited"
                                                              ? languagesController
                                                                    .tr(
                                                                      "UNLIMITED",
                                                                    )
                                                              : data.validityType
                                                                        .toString() ==
                                                                    "monthly"
                                                              ? languagesController
                                                                    .tr(
                                                                      "MONTHLY",
                                                                    )
                                                              : data.validityType
                                                                        .toString() ==
                                                                    "weekly"
                                                              ? languagesController
                                                                    .tr(
                                                                      "WEEKLY",
                                                                    )
                                                                    .toString()
                                                              : data.validityType
                                                                        .toString() ==
                                                                    "daily"
                                                              ? languagesController
                                                                    .tr("DAILY")
                                                              : data.validityType
                                                                        .toString() ==
                                                                    "hourly"
                                                              ? languagesController
                                                                    .tr(
                                                                      "HOURLY",
                                                                    )
                                                              : data.validityType
                                                                        .toString() ==
                                                                    "nightly"
                                                              ? languagesController
                                                                    .tr(
                                                                      "NIGHTLY",
                                                                    )
                                                              : "",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 50),
                                                  Positioned(
                                                    bottom: 0,
                                                    top: 0,
                                                    left: 110,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              languagesController
                                                                  .tr("SELL"),
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            PriceTextView(
                                                              price: data
                                                                  .sellingPrice
                                                                  .toString(),
                                                            ),
                                                            SizedBox(width: 2),
                                                            Text(
                                                              " ${box.read("currency_code")}",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: 100,
                                                    bottom: 0,
                                                    top: 0,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) {
                                                                return AlertDialog(
                                                                  content: Container(
                                                                    height: 50,
                                                                    width:
                                                                        screenWidth,
                                                                    child: Center(
                                                                      child: Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                languagesController.tr(
                                                                                  "BUY",
                                                                                ),
                                                                                style: TextStyle(
                                                                                  fontSize: 15,
                                                                                  color: Colors.black,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                NumberFormat.currency(
                                                                                  locale: 'en_US',
                                                                                  symbol: '',
                                                                                  decimalDigits: 2,
                                                                                ).format(
                                                                                  double.parse(
                                                                                    data.buyingPrice.toString(),
                                                                                  ),
                                                                                ),
                                                                                style: TextStyle(
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                "     ${box.read("currency_code")}",
                                                                                style: TextStyle(
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: Colors.black,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Text(
                                                            languagesController
                                                                .tr("DETAILS"),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: -100,
                                                    bottom: -40,
                                                    top: -40,
                                                    child: Container(
                                                      height: 200,
                                                      width: 200,
                                                      decoration: BoxDecoration(
                                                        color: Colors.green
                                                            .withOpacity(0.1),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: 10,
                                                    bottom: 5,
                                                    top: 5,
                                                    child: Container(
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        image: DecorationImage(
                                                          image:
                                                              CachedNetworkImageProvider(
                                                                (data
                                                                    .service!
                                                                    .company!
                                                                    .companyLogo
                                                                    .toString()),
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : bundleController.finalList.isEmpty
                                  ? SizedBox()
                                  : RefreshIndicator(
                                      onRefresh: refresh,
                                      child: ListView.separated(
                                        shrinkWrap: false,
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        controller: scrollController,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(height: 5);
                                        },
                                        itemCount:
                                            bundleController.finalList.length,
                                        itemBuilder: (context, index) {
                                          final data =
                                              bundleController.finalList[index];
                                          return GestureDetector(
                                            onTap: () {
                                              if (confirmPinController
                                                  .numberController
                                                  .text
                                                  .isEmpty) {
                                                Fluttertoast.showToast(
                                                  msg: languagesController.tr(
                                                    "ENTER_NUMBER",
                                                  ),
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.black,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              } else {
                                                if (box.read("permission") ==
                                                        "no" ||
                                                    confirmPinController
                                                            .numberController
                                                            .text
                                                            .length
                                                            .toString() !=
                                                        box
                                                            .read("maxlength")
                                                            .toString()) {
                                                  Fluttertoast.showToast(
                                                    msg: languagesController.tr(
                                                      "ENTER_CORRECT_NUMBER",
                                                    ),
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.black,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                  // Stop further execution if permission is "no"
                                                } else {
                                                  box.write(
                                                    "bundleID",
                                                    data.id.toString(),
                                                  );

                                                  Get.toNamed(confirmpinscreen);
                                                }
                                              }
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                top: 5,
                                                left: 2,
                                                right: 2,
                                              ),
                                              height: 60,
                                              width: screenWidth,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 2,
                                                    offset: Offset(0, 0),
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    bottom: 0,
                                                    top: 0,
                                                    left: 10,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data.bundleTitle
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 13,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          data.validityType
                                                                      .toString() ==
                                                                  "unlimited"
                                                              ? languagesController
                                                                    .tr(
                                                                      "UNLIMITED",
                                                                    )
                                                              : data.validityType
                                                                        .toString() ==
                                                                    "monthly"
                                                              ? languagesController
                                                                    .tr(
                                                                      "MONTHLY",
                                                                    )
                                                              : data.validityType
                                                                        .toString() ==
                                                                    "weekly"
                                                              ? languagesController
                                                                    .tr(
                                                                      "WEEKLY",
                                                                    )
                                                                    .toString()
                                                              : data.validityType
                                                                        .toString() ==
                                                                    "daily"
                                                              ? languagesController
                                                                    .tr("DAILY")
                                                              : data.validityType
                                                                        .toString() ==
                                                                    "hourly"
                                                              ? languagesController
                                                                    .tr(
                                                                      "HOURLY",
                                                                    )
                                                              : data.validityType
                                                                        .toString() ==
                                                                    "nightly"
                                                              ? languagesController
                                                                    .tr(
                                                                      "NIGHTLY",
                                                                    )
                                                              : "",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 50),
                                                  Positioned(
                                                    bottom: 0,
                                                    top: 0,
                                                    left: 110,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              languagesController
                                                                  .tr("SELL"),
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            PriceTextView(
                                                              price: data
                                                                  .sellingPrice
                                                                  .toString(),
                                                            ),
                                                            SizedBox(width: 2),
                                                            Text(
                                                              " ${box.read("currency_code")}",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: 100,
                                                    bottom: 0,
                                                    top: 0,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) {
                                                                return AlertDialog(
                                                                  content: Container(
                                                                    height: 50,
                                                                    width:
                                                                        screenWidth,
                                                                    child: Center(
                                                                      child: Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                languagesController.tr(
                                                                                  "BUY",
                                                                                ),
                                                                                style: TextStyle(
                                                                                  fontSize: 15,
                                                                                  color: Colors.black,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                NumberFormat.currency(
                                                                                  locale: 'en_US',
                                                                                  symbol: '',
                                                                                  decimalDigits: 2,
                                                                                ).format(
                                                                                  double.parse(
                                                                                    data.buyingPrice.toString(),
                                                                                  ),
                                                                                ),
                                                                                style: TextStyle(
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                "     ${box.read("currency_code")}",
                                                                                style: TextStyle(
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: Colors.black,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Text(
                                                            languagesController
                                                                .tr("DETAILS"),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: -100,
                                                    bottom: -40,
                                                    top: -40,
                                                    child: Container(
                                                      height: 200,
                                                      width: 200,
                                                      decoration: BoxDecoration(
                                                        color: Colors.green
                                                            .withOpacity(0.1),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: 10,
                                                    bottom: 5,
                                                    top: 5,
                                                    child: Container(
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        image: DecorationImage(
                                                          image:
                                                              CachedNetworkImageProvider(
                                                                (data
                                                                    .service!
                                                                    .company!
                                                                    .companyLogo
                                                                    .toString()),
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            ),
                          ),
                          Obx(
                            () => bundleController.isLoading.value == true
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: AppColors.defaultColor,
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

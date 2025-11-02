// import 'dart:async';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:amutelecom/controllers/categories_list_controller.dart';
// import 'package:amutelecom/controllers/country_list_controller.dart';
// import 'package:amutelecom/controllers/dashboard_controller.dart';
// import 'package:amutelecom/controllers/history_controller.dart';
// import 'package:amutelecom/controllers/language_controller.dart';
// import 'package:amutelecom/controllers/slider_controller.dart';

// import 'package:amutelecom/helpers/language_helper.dart';
// import 'package:amutelecom/routes/routes.dart';
// import 'package:amutelecom/screens/order_details.dart';
// import 'package:amutelecom/utils/colors.dart';
// import 'package:amutelecom/widgets/drawer.dart';

// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'package:intl/intl.dart';

// class Drafthome extends StatefulWidget {
//   const Drafthome({super.key});

//   @override
//   State<Drafthome> createState() => _DrafthomeState();
// }

// class _DrafthomeState extends State<Drafthome> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   final box = GetStorage();
//   int currentindex = 0;

//   PageController _pageController = PageController(
//     initialPage: 0,
//     viewportFraction: 1.0,
//   );

//   int currentSliderindex = 0;

//   Timer? _timer;

//   void _startAutoSlide() {
//     _timer = Timer.periodic(Duration(seconds: 3), (timer) {
//       if (currentSliderindex <
//           sliderController.allsliderlist.value.data!.advertisements.length -
//               1) {
//         currentSliderindex++;
//       } else {
//         currentSliderindex = 0;
//       }
//       _pageController.animateToPage(
//         currentSliderindex,
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//       setState(() {});
//     });
//   }

//   String permission = "yes";

//   @override
//   void initState() {
//     super.initState();
//     _startAutoSlide();
//     historyController.finalList.clear();
//     historyController.fetchHistory();
//     // languageController.fetchlanData(box.read("isoCode"));
//     dashboardController.fetchDashboardData();

//     // Use addPostFrameCallback to ensure this runs after the initial build
//   }

//   Future<void> refresh() async {
//     final int totalPages =
//         historyController.allorderlist.value.payload?.pagination.totalPages ??
//             0;
//     final int currentPage = historyController.initialpage;

//     // Prevent loading more pages if we've reached the last page
//     if (currentPage >= totalPages) {
//       print(
//           "End..........................................End.....................");
//       return;
//     }

//     // Check if the scroll position is at the bottom
//     if (scrollController.position.pixels ==
//         scrollController.position.maxScrollExtent) {
//       historyController.initialpage++;

//       // Prevent fetching if the next page exceeds total pages
//       if (historyController.initialpage <= totalPages) {
//         print("Load More...................");
//         historyController.fetchHistory();
//       } else {
//         historyController.initialpage =
//             totalPages; // Reset to the last valid page
//         print("Already on the last page");
//       }
//     }
//   }

//   final dashboardController = Get.find<DashboardController>();
//   final historyController = Get.find<HistoryController>();
//   final languageController = Get.find<LanguageController>();
//   final sliderController = Get.find<SliderController>();
//   final countryListController = Get.find<CountryListController>();
//   final categorisListController = Get.find<CategorisListController>();

//   final ScrollController scrollController = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     var screenHeight = MediaQuery.of(context).size.height;
//     var screenWidth = MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           leading: GestureDetector(
//             onTap: () {
//               _scaffoldKey.currentState?.openDrawer();
//             },
//             child: Icon(
//               Icons.sort,
//             ),
//           ),
//           elevation: 0.0,
//           backgroundColor: AppColors.defaultColor,
//           title: Row(
//             children: [
//               Obx(
//                 () => dashboardController.isLoading.value == false
//                     ? GestureDetector(
//                         onTap: () {
//                           print(
//                             languageController
//                                 .alllanguageData.value.languageData!["HOME"]
//                                 .toString(),
//                           );
//                         },
//                         child: Text(
//                           dashboardController.alldashboardData.value.data!
//                               .userInfo!.resellerName
//                               .toString(),
//                           style: GoogleFonts.rubik(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       )
//                     : SizedBox(),
//               ),
//             ],
//           ),
//         ),
//         drawer: DrawerWidget(),
//         key: _scaffoldKey,
//         body: Container(
//           color: Color(0xffEFF3F4),
//           height: screenHeight,
//           width: screenHeight,
//           child: Column(
//             children: [
//               Container(
//                 height: 180,
//                 width: screenWidth,
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 180,
//                       child: Obx(
//                         () => sliderController.isLoading.value == false
//                             ? PageView.builder(
//                                 itemCount: sliderController.allsliderlist.value
//                                     .data!.advertisements.length,
//                                 physics: BouncingScrollPhysics(),
//                                 controller: _pageController,
//                                 onPageChanged: (value) {
//                                   currentindex = value;
//                                   setState(() {});
//                                 },
//                                 itemBuilder: (context, index) {
//                                   return Container(
//                                     width: screenWidth,
//                                     margin: EdgeInsets.all(8),
//                                     clipBehavior: Clip.antiAlias,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(16),
//                                     ),
//                                     child: Stack(
//                                       children: [
//                                         Image.network(
//                                           sliderController
//                                               .allsliderlist
//                                               .value
//                                               .data!
//                                               .advertisements[index]
//                                               .adSliderImageUrl
//                                               .toString(),
//                                           fit: BoxFit.fill,
//                                           width: double.infinity,
//                                           height: double.infinity,
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               )
//                             : Center(
//                                 child: CircularProgressIndicator(
//                                   color: AppColors.defaultColor,
//                                 ),
//                               ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Obx(
//                 () => dashboardController.isLoading.value == false
//                     ? Container(
//                         margin: EdgeInsets.symmetric(horizontal: 13),
//                         height: 130,
//                         // color: AppColors.defaultColor,
//                         width: screenWidth,
//                         child: Column(
//                           children: [
//                             Expanded(
//                               flex: 3,
//                               child: Container(
//                                 decoration: BoxDecoration(),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.grey.withOpacity(
//                                                   0.2), // shadow color
//                                               spreadRadius: 2, // spread radius
//                                               blurRadius: 2, // blur radius
//                                               offset: Offset(0,
//                                                   0), // changes position of shadow
//                                             ),
//                                           ],
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                         ),
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(
//                                             left: 10,
//                                             right: 8,
//                                           ),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Row(
//                                                     // mainAxisAlignment:
//                                                     //     MainAxisAlignment.center,
//                                                     children: [
//                                                       Image.asset(
//                                                         "assets/icons/balance-sheet.png",
//                                                         height: 20,
//                                                       ),
//                                                       SizedBox(
//                                                         width: 7,
//                                                       ),
//                                                       Text(
//                                                         getText("BALANCE",
//                                                             defaultValue:
//                                                                 "Balance"),
//                                                         style: TextStyle(
//                                                           fontSize: 12,
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   SizedBox(
//                                                     height: 5,
//                                                   ),
//                                                   Row(
//                                                     // mainAxisAlignment:
//                                                     //     MainAxisAlignment.center,
//                                                     children: [
//                                                       Text(
//                                                         NumberFormat.currency(
//                                                           locale: 'en_US',
//                                                           symbol: '',
//                                                           decimalDigits: 2,
//                                                         ).format(
//                                                           double.parse(
//                                                             dashboardController
//                                                                 .alldashboardData
//                                                                 .value
//                                                                 .data!
//                                                                 .balance
//                                                                 .toString(),
//                                                           ),
//                                                         ),
//                                                         style: TextStyle(
//                                                           fontSize: 12,
//                                                           fontWeight:
//                                                               FontWeight.w800,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         width: 7,
//                                                       ),
//                                                       Text(
//                                                         "${box.read("currency_code")}",
//                                                         style: TextStyle(
//                                                           fontSize: 10,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                               Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Row(
//                                                     // mainAxisAlignment:
//                                                     //     MainAxisAlignment.center,
//                                                     children: [
//                                                       Image.asset(
//                                                         "assets/icons/investment.png",
//                                                         height: 20,
//                                                       ),
//                                                       SizedBox(
//                                                         width: 7,
//                                                       ),
//                                                       Text(
//                                                         getText("LOAN_BALANCE",
//                                                             defaultValue:
//                                                                 "Loan Balance"),
//                                                         style: TextStyle(
//                                                           fontSize: 12,
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   SizedBox(
//                                                     height: 5,
//                                                   ),
//                                                   Row(
//                                                     // mainAxisAlignment:
//                                                     //     MainAxisAlignment.center,
//                                                     children: [
//                                                       Text(
//                                                         NumberFormat.currency(
//                                                           locale: 'en_US',
//                                                           symbol: '',
//                                                           decimalDigits: 2,
//                                                         ).format(
//                                                           double.parse(
//                                                             dashboardController
//                                                                 .alldashboardData
//                                                                 .value
//                                                                 .data!
//                                                                 .loanBalance
//                                                                 .toString(),
//                                                           ),
//                                                         ),
//                                                         style: TextStyle(
//                                                           fontSize: 12,
//                                                           fontWeight:
//                                                               FontWeight.w800,
//                                                           color: Colors.red,
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         width: 7,
//                                                       ),
//                                                       Text(
//                                                         "${box.read("currency_code")}",
//                                                         style: TextStyle(
//                                                           fontSize: 10,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Expanded(
//                               flex: 3,
//                               child: Container(
//                                 decoration: BoxDecoration(),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.grey.withOpacity(
//                                                   0.2), // shadow color
//                                               spreadRadius: 2, // spread radius
//                                               blurRadius: 2, // blur radius
//                                               offset: Offset(0,
//                                                   0), // changes position of shadow
//                                             ),
//                                           ],
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                         ),
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(
//                                             left: 10,
//                                             right: 8,
//                                           ),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Row(
//                                                     children: [
//                                                       Image.asset(
//                                                         "assets/icons/sales.png",
//                                                         height: 20,
//                                                       ),
//                                                       SizedBox(
//                                                         width: 7,
//                                                       ),
//                                                       Text(
//                                                         getText("SALE",
//                                                             defaultValue:
//                                                                 "Sale"),
//                                                         style: TextStyle(
//                                                           fontSize: 12,
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   Row(
//                                                     // mainAxisAlignment:
//                                                     //     MainAxisAlignment.center,
//                                                     children: [
//                                                       Text(
//                                                         getText("TODAY_SALE",
//                                                             defaultValue:
//                                                                 "Today Sale : "),
//                                                         style: TextStyle(
//                                                           fontSize: 10,
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         width: 7,
//                                                       ),
//                                                       Text(
//                                                         NumberFormat.currency(
//                                                           locale: 'en_US',
//                                                           symbol: '',
//                                                           decimalDigits: 2,
//                                                         ).format(
//                                                           double.parse(
//                                                             dashboardController
//                                                                 .alldashboardData
//                                                                 .value
//                                                                 .data!
//                                                                 .todaySale
//                                                                 .toString(),
//                                                           ),
//                                                         ),
//                                                         style: TextStyle(
//                                                           fontSize: 12,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         width: 7,
//                                                       ),
//                                                       Text(
//                                                         "${box.read("currency_code")}",
//                                                         style: TextStyle(
//                                                           fontSize: 10,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   Row(
//                                                     // mainAxisAlignment:
//                                                     //     MainAxisAlignment.center,
//                                                     children: [
//                                                       Text(
//                                                         getText("TOTAL_SALE",
//                                                             defaultValue:
//                                                                 "Total Sale "),
//                                                         style: TextStyle(
//                                                           fontSize: 11,
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         width: 7,
//                                                       ),
//                                                       Text(
//                                                         NumberFormat.currency(
//                                                           locale: 'en_US',
//                                                           symbol: '',
//                                                           decimalDigits: 2,
//                                                         ).format(
//                                                           double.parse(
//                                                             dashboardController
//                                                                 .alldashboardData
//                                                                 .value
//                                                                 .data!
//                                                                 .totalSoldAmount
//                                                                 .toString(),
//                                                           ),
//                                                         ),
//                                                         style: TextStyle(
//                                                           fontSize: 12,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         width: 7,
//                                                       ),
//                                                       Text(
//                                                         "${box.read("currency_code")}",
//                                                         style: TextStyle(
//                                                           fontSize: 10,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                               Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Row(
//                                                     // mainAxisAlignment:
//                                                     //     MainAxisAlignment.center,
//                                                     children: [
//                                                       Image.asset(
//                                                         "assets/icons/profits.png",
//                                                         height: 20,
//                                                       ),
//                                                       SizedBox(
//                                                         width: 7,
//                                                       ),
//                                                       Text(
//                                                         getText("PROFIT",
//                                                             defaultValue:
//                                                                 "Profit"),
//                                                         style: TextStyle(
//                                                           fontSize: 10,
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   Row(
//                                                     // mainAxisAlignment:
//                                                     //     MainAxisAlignment.center,
//                                                     children: [
//                                                       Text(
//                                                         getText("TODAY_PROFIT",
//                                                             defaultValue:
//                                                                 "Today Profit : "),
//                                                         style: TextStyle(
//                                                           fontSize: 10,
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         width: 7,
//                                                       ),
//                                                       Text(
//                                                         NumberFormat.currency(
//                                                           locale: 'en_US',
//                                                           symbol: '',
//                                                           decimalDigits: 2,
//                                                         ).format(
//                                                           double.parse(
//                                                             dashboardController
//                                                                 .alldashboardData
//                                                                 .value
//                                                                 .data!
//                                                                 .todayProfit
//                                                                 .toString(),
//                                                           ),
//                                                         ),
//                                                         style: TextStyle(
//                                                           fontSize: 12,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         width: 7,
//                                                       ),
//                                                       Text(
//                                                         "${box.read("currency_code")}",
//                                                         style: TextStyle(
//                                                           fontSize: 10,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   Row(
//                                                     // mainAxisAlignment:
//                                                     //     MainAxisAlignment.center,
//                                                     children: [
//                                                       Text(
//                                                         getText("TOTAL_PROFIT",
//                                                             defaultValue:
//                                                                 "Total Profit"),
//                                                         style: TextStyle(
//                                                           fontSize: 11,
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         width: 7,
//                                                       ),
//                                                       Text(
//                                                         NumberFormat.currency(
//                                                           locale: 'en_US',
//                                                           symbol: '',
//                                                           decimalDigits: 2,
//                                                         ).format(
//                                                           double.parse(
//                                                             dashboardController
//                                                                 .alldashboardData
//                                                                 .value
//                                                                 .data!
//                                                                 .totalRevenue
//                                                                 .toString(),
//                                                           ),
//                                                         ),
//                                                         style: TextStyle(
//                                                           fontSize: 12,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         width: 7,
//                                                       ),
//                                                       Text(
//                                                         "${box.read("currency_code")}",
//                                                         style: TextStyle(
//                                                           fontSize: 10,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ))
//                     : SizedBox(),
//               ),

//               SizedBox(
//                 height: 10,
//               ),

//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 13),
//                 child: Container(
//                   height: 55,
//                   width: screenWidth,
//                   // color: Colors.purple,
//                   child: Row(
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: GestureDetector(
//                           onTap: () {
//                             categorisListController.nonsocialArray.clear();
//                             categorisListController.fetchcategories();
//                             Get.toNamed(newservicescreen);
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               // borderRadius: BorderRadius.circular(7),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.2),
//                                   spreadRadius: 2,
//                                   blurRadius: 2,
//                                   offset: Offset(0, 0),
//                                 ),
//                               ],
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   Icon(
//                                     FontAwesomeIcons.paperPlane,
//                                     color: Colors.grey,
//                                   ),
//                                   // Text(
//                                   //   "Bundle Recharge",
//                                   //   style: TextStyle(
//                                   //     fontSize: 14,
//                                   //     color: Colors.black,
//                                   //     fontWeight: FontWeight.w700,
//                                   //   ),
//                                   // ),
//                                   Obx(
//                                     () => Text(
//                                       getText("BUNDLE_RECHARGE",
//                                           defaultValue: "Bundle Recharge"),
//                                       style: TextStyle(
//                                         fontSize: 13,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 8,
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: GestureDetector(
//                           onTap: () {
//                             if (countryListController
//                                 .finalCountryList.isNotEmpty) {
//                               // Find the country where the name is "Afghanistan"
//                               var afghanistan = countryListController
//                                   .finalCountryList
//                                   .firstWhere(
//                                 (country) =>
//                                     country['country_name'] == "Afghanistan",
//                                 orElse: () => null, // Return null if not found
//                               );

//                               if (afghanistan != null) {
//                                 print(
//                                     "The ID for Afghanistan is: ${afghanistan['id']}");
//                                 box.write("country_id", "${afghanistan['id']}");
//                                 box.write("maxlength", "10");
//                               } else {
//                                 print("Afghanistan not found in the list");
//                               }
//                             } else {
//                               print("Country list is empty.");
//                             }
//                             Get.toNamed(customrechargescreen);
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               // borderRadius: BorderRadius.circular(7),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.2),
//                                   spreadRadius: 2,
//                                   blurRadius: 2,
//                                   offset: Offset(0, 0),
//                                 ),
//                               ],
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   Icon(
//                                     FontAwesomeIcons.ticket,
//                                     color: Colors.grey,
//                                   ),
//                                   Obx(
//                                     () => Text(
//                                       getText("CUSTOM_RECHARGE",
//                                           defaultValue: "Custom Recharge"),
//                                       style: TextStyle(
//                                         fontSize: 13,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                   )
//                                   // Text(
//                                   //   "Custom Recharge",
//                                   //   style: TextStyle(
//                                   //     fontSize: 14,
//                                   //     color: Colors.black,
//                                   //     fontWeight: FontWeight.w700,
//                                   //   ),
//                                   // ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Obx(
//                 () => historyController.isLoading.value == false
//                     ? Container(
//                         child: historyController
//                                 .allorderlist.value.data!.orders.isNotEmpty
//                             ? SizedBox()
//                             : Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image.asset(
//                                       "assets/icons/empty.png",
//                                       height: 80,
//                                     ),
//                                     Text("No Data found"),
//                                   ],
//                                 ),
//                               ),
//                       )
//                     : SizedBox(),
//               ),

//               Expanded(
//                 child: Obx(() => historyController.isLoading.value == false &&
//                         languageController.isLoading.value == false &&
//                         historyController.finalList.isNotEmpty
//                     ? RefreshIndicator(
//                         onRefresh: refresh,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 13),
//                           child: ListView.separated(
//                             shrinkWrap: false,
//                             physics: AlwaysScrollableScrollPhysics(),
//                             controller: scrollController,
//                             separatorBuilder: (context, index) {
//                               return SizedBox(
//                                 height: 5,
//                               );
//                             },
//                             itemCount: historyController.finalList.length,
//                             itemBuilder: (context, index) {
//                               final data = historyController.finalList[index];
//                               return GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => OrderDetailsScreen(
//                                         createDate: data.createdAt.toString(),
//                                         status: data.status.toString(),
//                                         rejectReason:
//                                             data.rejectReason.toString(),
//                                         companyName: data.bundle!.service!
//                                             .company!.companyName
//                                             .toString(),
//                                         bundleTitle: data.bundle!.bundleTitle!
//                                             .toString(),
//                                         rechargebleAccount:
//                                             data.rechargebleAccount!.toString(),
//                                         validityType: data.bundle!.validityType!
//                                             .toString(),
//                                         sellingPrice: data.bundle!.sellingPrice
//                                             .toString(),
//                                         orderID: data.id!.toString(),
//                                         resellerName: dashboardController
//                                             .alldashboardData
//                                             .value
//                                             .data!
//                                             .userInfo!
//                                             .contactName
//                                             .toString(),
//                                         resellerPhone: dashboardController
//                                             .alldashboardData
//                                             .value
//                                             .data!
//                                             .userInfo!
//                                             .phone
//                                             .toString(),
//                                         companyLogo: data.bundle!.service!
//                                             .company!.companyLogo
//                                             .toString(),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                   height: 60,
//                                   width: screenWidth,
//                                   decoration: BoxDecoration(
//                                     // border: Border.all(
//                                     //   width: 1,
//                                     //   color: Colors.grey,
//                                     // ),
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: AppColors.listbuilderboxColor,
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(5.0),
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           height: 40,
//                                           width: 40,
//                                           decoration: BoxDecoration(
//                                             image: DecorationImage(
//                                               fit: BoxFit.fill,
//                                               image: NetworkImage(
//                                                 data.bundle!.service!.company!
//                                                     .companyLogo
//                                                     .toString(),
//                                               ),
//                                             ),
//                                             shape: BoxShape.circle,
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 5,
//                                         ),
//                                         Expanded(
//                                           flex: 2,
//                                           child: Padding(
//                                             padding:
//                                                 const EdgeInsets.only(left: 5),
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Flexible(
//                                                   child: Text(
//                                                     data.bundle!.bundleTitle
//                                                         .toString(),
//                                                     style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                       fontSize: 14,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   data.rechargebleAccount
//                                                       .toString(),
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.w500,
//                                                     fontSize: 12,
//                                                     color: Colors.grey,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 5,
//                                         ),
//                                         Expanded(
//                                           flex: 2,
//                                           child: Row(
//                                             children: [
//                                               Text(
//                                                 NumberFormat.currency(
//                                                   locale: 'en_US',
//                                                   symbol: '',
//                                                   decimalDigits: 2,
//                                                 ).format(
//                                                   double.parse(
//                                                     data.bundle!.sellingPrice
//                                                         .toString(),
//                                                   ),
//                                                 ),
//                                                 style: TextStyle(
//                                                   fontSize: 11,
//                                                   fontWeight: FontWeight.w600,
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 2,
//                                               ),
//                                               Text(
//                                                 " " + box.read("currency_code"),
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 11,
//                                                   color: Colors.grey,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 2,
//                                           child: Container(
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 // Icon(
//                                                 //   Icons.check,
//                                                 //   color: Colors.green,
//                                                 //   size: 14,
//                                                 // ),
//                                                 Text(
//                                                   data.status.toString() == "0"
//                                                       ? languageController
//                                                           .alllanguageData
//                                                           .value
//                                                           .languageData![
//                                                               "PENDING"]
//                                                           .toString()
//                                                       : data.status
//                                                                   .toString() ==
//                                                               "1"
//                                                           ? languageController
//                                                               .alllanguageData
//                                                               .value
//                                                               .languageData![
//                                                                   "CONFIRMED"]
//                                                               .toString()
//                                                           : languageController
//                                                               .alllanguageData
//                                                               .value
//                                                               .languageData![
//                                                                   "REJECTED"]
//                                                               .toString(),
//                                                   style: TextStyle(
//                                                     fontSize: 12,
//                                                     color: Colors.black,
//                                                     fontWeight: FontWeight.w800,
//                                                   ),
//                                                 ),
//                                                 // Text(
//                                                 //   "2 days ago",
//                                                 //   style: TextStyle(
//                                                 //     color: Colors.green,
//                                                 //     fontSize: 10,
//                                                 //     fontWeight:
//                                                 //         FontWeight.w600,
//                                                 //   ),
//                                                 // ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       )
//                     : historyController.finalList.isEmpty
//                         ? SizedBox()
//                         : RefreshIndicator(
//                             onRefresh: refresh,
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 13),
//                               child: ListView.separated(
//                                 shrinkWrap: false,
//                                 physics: AlwaysScrollableScrollPhysics(),
//                                 controller: scrollController,
//                                 separatorBuilder: (context, index) {
//                                   return SizedBox(
//                                     height: 5,
//                                   );
//                                 },
//                                 itemCount: historyController.finalList.length,
//                                 itemBuilder: (context, index) {
//                                   final data =
//                                       historyController.finalList[index];
//                                   return GestureDetector(
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               OrderDetailsScreen(
//                                             createDate:
//                                                 data.createdAt.toString(),
//                                             status: data.status.toString(),
//                                             rejectReason:
//                                                 data.rejectReason.toString(),
//                                             companyName: data.bundle!.service!
//                                                 .company!.companyName
//                                                 .toString(),
//                                             bundleTitle: data
//                                                 .bundle!.bundleTitle!
//                                                 .toString(),
//                                             rechargebleAccount: data
//                                                 .rechargebleAccount!
//                                                 .toString(),
//                                             validityType: data
//                                                 .bundle!.validityType!
//                                                 .toString(),
//                                             sellingPrice: data
//                                                 .bundle!.sellingPrice
//                                                 .toString(),
//                                             orderID: data.id!.toString(),
//                                             resellerName: dashboardController
//                                                 .alldashboardData
//                                                 .value
//                                                 .data!
//                                                 .userInfo!
//                                                 .contactName
//                                                 .toString(),
//                                             resellerPhone: dashboardController
//                                                 .alldashboardData
//                                                 .value
//                                                 .data!
//                                                 .userInfo!
//                                                 .phone
//                                                 .toString(),
//                                             companyLogo: data.bundle!.service!
//                                                 .company!.companyLogo
//                                                 .toString(),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     child: Container(
//                                       height: 60,
//                                       width: screenWidth,
//                                       decoration: BoxDecoration(
//                                         // border: Border.all(
//                                         //   width: 1,
//                                         //   color: Colors.grey,
//                                         // ),
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: AppColors.listbuilderboxColor,
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(5.0),
//                                         child: Row(
//                                           children: [
//                                             Container(
//                                               height: 40,
//                                               width: 40,
//                                               decoration: BoxDecoration(
//                                                 image: DecorationImage(
//                                                   fit: BoxFit.fill,
//                                                   image: NetworkImage(
//                                                     data.bundle!.service!
//                                                         .company!.companyLogo
//                                                         .toString(),
//                                                   ),
//                                                 ),
//                                                 shape: BoxShape.circle,
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               width: 5,
//                                             ),
//                                             Expanded(
//                                               flex: 2,
//                                               child: Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     left: 5),
//                                                 child: Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Flexible(
//                                                       child: Text(
//                                                         data.bundle!.bundleTitle
//                                                             .toString(),
//                                                         style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                           fontSize: 14,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       data.rechargebleAccount
//                                                           .toString(),
//                                                       style: TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         fontSize: 12,
//                                                         color: Colors.grey,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               width: 5,
//                                             ),
//                                             Expanded(
//                                               flex: 2,
//                                               child: Row(
//                                                 children: [
//                                                   Text(
//                                                     NumberFormat.currency(
//                                                       locale: 'en_US',
//                                                       symbol: '',
//                                                       decimalDigits: 2,
//                                                     ).format(
//                                                       double.parse(
//                                                         data.bundle!
//                                                             .sellingPrice
//                                                             .toString(),
//                                                       ),
//                                                     ),
//                                                     style: TextStyle(
//                                                       fontSize: 11,
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 2,
//                                                   ),
//                                                   Text(
//                                                     " " +
//                                                         box.read(
//                                                             "currency_code"),
//                                                     style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                       fontSize: 11,
//                                                       color: Colors.grey,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             Expanded(
//                                               flex: 2,
//                                               child: Container(
//                                                 child: Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     // Icon(
//                                                     //   Icons.check,
//                                                     //   color: Colors.green,
//                                                     //   size: 14,
//                                                     // ),
//                                                     Text(
//                                                       data.status.toString() ==
//                                                               "0"
//                                                           ? languageController
//                                                               .alllanguageData
//                                                               .value
//                                                               .languageData![
//                                                                   "PENDING"]
//                                                               .toString()
//                                                           : data.status
//                                                                       .toString() ==
//                                                                   "1"
//                                                               ? languageController
//                                                                   .alllanguageData
//                                                                   .value
//                                                                   .languageData![
//                                                                       "CONFIRMED"]
//                                                                   .toString()
//                                                               : languageController
//                                                                   .alllanguageData
//                                                                   .value
//                                                                   .languageData![
//                                                                       "REJECTED"]
//                                                                   .toString(),
//                                                       style: TextStyle(
//                                                         fontSize: 12,
//                                                         color: Colors.black,
//                                                         fontWeight:
//                                                             FontWeight.w800,
//                                                       ),
//                                                     ),
//                                                     // Text(
//                                                     //   "2 days ago",
//                                                     //   style: TextStyle(
//                                                     //     color: Colors.green,
//                                                     //     fontSize: 10,
//                                                     //     fontWeight:
//                                                     //         FontWeight.w600,
//                                                     //   ),
//                                                     // ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           )),
//               ),

//               Obx(
//                 () => historyController.isLoading.value == true
//                     ? Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Center(
//                             child: CircularProgressIndicator(
//                               color: AppColors.defaultColor,
//                             ),
//                           ),
//                         ],
//                       )
//                     : SizedBox(),
//               ),
//               // SizedBox(
//               //   height: 22,
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

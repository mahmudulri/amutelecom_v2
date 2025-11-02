// import 'package:convex_bottom_bar/convex_bottom_bar.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:floating_action_bubble/floating_action_bubble.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:amutelecom/controllers/country_list_controller.dart';
// import 'package:amutelecom/controllers/dashboard_controller.dart';
// import 'package:amutelecom/controllers/history_controller.dart';
// import 'package:amutelecom/controllers/language_controller.dart';
// import 'package:amutelecom/controllers/order_list_controller.dart';
// import 'package:amutelecom/controllers/transaction_controller.dart';
// import 'package:amutelecom/helpers/language_helper.dart';
// import 'package:amutelecom/pages/homepage.dart';
// import 'package:amutelecom/pages/orders.dart';
// import 'package:amutelecom/pages/sub_reseller_screen.dart';
// import 'package:amutelecom/pages/transactions.dart';
// import 'package:amutelecom/routes/routes.dart';
// import 'package:amutelecom/utils/colors.dart';
// import 'package:amutelecom/widgets/drawer.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';

// class DraftBase extends StatefulWidget {
//   const DraftBase({super.key});

//   @override
//   State<DraftBase> createState() => _DraftBaseState();
// }

// class _DraftBaseState extends State<DraftBase>
//     with SingleTickerProviderStateMixin {
//   List pages = [
//     Homepage(),
//     TransactionsPage(),
//     OrdersPage(),
//     SubResellerScreen(),
//   ];
//   final box = GetStorage();
//   var currentIndex = 0;

//   final historyController = Get.find<HistoryController>();

//   final transactionController = Get.find<TransactionController>();
//   final countryListController = Get.find<CountryListController>();
//   final orderlistController = Get.find<OrderlistController>();
//   final dashboardController = Get.find<DashboardController>();

//   final languageController = Get.find<LanguageController>();
//   Animation<double>? _animation;
//   AnimationController? _animationController;

//   @override
//   void initState() {
//     // languageController.fetchlanData(box.read("isoCode"));
//     countryListController.fetchCountryData();

//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 260),
//     );
//     final curvedAnimation =
//         CurvedAnimation(curve: Curves.easeInOut, parent: _animationController!);
//     _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
//     super.initState();
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
//       statusBarColor: AppColors.defaultColor,
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     double displayWidth = MediaQuery.of(context).size.width;
//     Future<bool> showExitPopup() async {
//       return await showDialog(
//             //show confirm dialogue
//             //the return value will be from "Yes" or "No" options
//             context: context,
//             builder: (context) => AlertDialog(
//               title: Text('Exit App'),
//               content: Text('Do you want to exit an App?'),
//               actions: [
//                 ElevatedButton(
//                   onPressed: () => Navigator.of(context).pop(false),
//                   //return false when click on "NO"
//                   child: Text('No'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     SystemNavigator.pop();
//                   },
//                   //return true when click on "Yes"
//                   child: Text('Yes'),
//                 ),
//               ],
//             ),
//           ) ??
//           false; //if showDialouge had returned null, then return false
//     }

//     return WillPopScope(
//       onWillPop: () async {
//         final shouldExit = await showExitPopup();
//         return shouldExit;
//       },
//       child: SafeArea(
//         child: Scaffold(
//           bottomNavigationBar: Container(
//               margin: EdgeInsets.only(
//                 left: displayWidth * .05,
//                 right: displayWidth * .05,
//                 bottom: 10,
//               ),
//               height: displayWidth * .155,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(.1),
//                     blurRadius: 30,
//                     offset: Offset(0, 10),
//                   ),
//                 ],
//                 borderRadius: BorderRadius.circular(50),
//               ),
//               child: ListView.builder(
//                 itemCount: 4,
//                 scrollDirection: Axis.horizontal,
//                 padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
//                 itemBuilder: (context, index) => InkWell(
//                   onTap: () {
//                     setState(() {
//                       currentIndex = index;
//                       HapticFeedback.lightImpact();
//                     });
//                   },
//                   splashColor: Colors.transparent,
//                   highlightColor: Colors.transparent,
//                   child: Stack(
//                     children: [
//                       AnimatedContainer(
//                         duration: Duration(seconds: 1),
//                         curve: Curves.fastLinearToSlowEaseIn,
//                         width: index == currentIndex
//                             ? displayWidth * .32
//                             : displayWidth * .18,
//                         alignment: Alignment.center,
//                         child: AnimatedContainer(
//                           duration: Duration(seconds: 1),
//                           curve: Curves.fastLinearToSlowEaseIn,
//                           height:
//                               index == currentIndex ? displayWidth * .12 : 0,
//                           width: index == currentIndex ? displayWidth * .32 : 0,
//                           decoration: BoxDecoration(
//                             color: index == currentIndex
//                                 ? Colors.blueAccent.withOpacity(.2)
//                                 : Colors.transparent,
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                         ),
//                       ),
//                       AnimatedContainer(
//                         duration: Duration(seconds: 1),
//                         curve: Curves.fastLinearToSlowEaseIn,
//                         width: index == currentIndex
//                             ? displayWidth * .31
//                             : displayWidth * .18,
//                         alignment: Alignment.center,
//                         child: Stack(
//                           children: [
//                             Row(
//                               children: [
//                                 AnimatedContainer(
//                                   duration: Duration(seconds: 1),
//                                   curve: Curves.fastLinearToSlowEaseIn,
//                                   width: index == currentIndex
//                                       ? displayWidth * .13
//                                       : 0,
//                                 ),
//                                 AnimatedOpacity(
//                                   opacity: index == currentIndex ? 1 : 0,
//                                   duration: Duration(seconds: 1),
//                                   curve: Curves.fastLinearToSlowEaseIn,
//                                   child: Obx(() =>
//                                       languageController.isLoading.value ==
//                                               false
//                                           ? Text(
//                                               currentIndex == 0
//                                                   ? getText("HOME",
//                                                       defaultValue: "Home")
//                                                   : currentIndex == 1
//                                                       ? getText("TRANSACTIONS",
//                                                           defaultValue:
//                                                               "Transactions")
//                                                       : currentIndex == 2
//                                                           ? getText("ORDERS",
//                                                               defaultValue:
//                                                                   "Orders")
//                                                           : currentIndex == 3
//                                                               ? getText(
//                                                                   "SUB_RESELLER",
//                                                                   defaultValue:
//                                                                       "Sub Reseller")
//                                                               : "",
//                                               style: TextStyle(
//                                                 color: Colors.blueAccent,
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 10,
//                                               ),
//                                             )
//                                           : SizedBox()),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 AnimatedContainer(
//                                   duration: Duration(seconds: 1),
//                                   curve: Curves.fastLinearToSlowEaseIn,
//                                   width: index == currentIndex
//                                       ? displayWidth * .03
//                                       : 20,
//                                 ),
//                                 // Icon(
//                                 //   listOfIcons[index],
//                                 //   size: displayWidth * .076,
//                                 //   color: index == currentIndex
//                                 //       ? Colors.blueAccent
//                                 //       : Colors.black26,
//                                 // ),

//                                 Image.asset(
//                                   imagedata[index],
//                                   height: 18,
//                                   color: index == currentIndex
//                                       ? Colors.blueAccent
//                                       : Colors.black26,
//                                 )
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )),
//           body: pages[currentIndex],
//         ),
//       ),
//     );
//   }

//   // List<IconData> listOfIcons = [
//   //   Icons.home_rounded,
//   //   Icons.favorite_rounded,
//   //   Icons.settings_rounded,
//   //   Icons.person_rounded,
//   // ];

//   List<String> imagedata = [
//     "assets/icons/homeicon.png",
//     "assets/icons/transactionsicon.png",
//     "assets/icons/notificationicon.png",
//     "assets/icons/sub_reseller.png",
//   ];
// }

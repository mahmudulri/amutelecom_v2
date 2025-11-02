import 'dart:async';
import 'package:amutelecom/controllers/bundles_controller.dart';
import 'package:amutelecom/controllers/service_controller.dart';
import 'package:amutelecom/screens/order_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:amutelecom/controllers/categories_list_controller.dart';
import 'package:amutelecom/controllers/country_list_controller.dart';
import 'package:amutelecom/controllers/dashboard_controller.dart';
import 'package:amutelecom/controllers/history_controller.dart';
import 'package:amutelecom/controllers/slider_controller.dart';
import 'package:amutelecom/routes/routes.dart';
import 'package:amutelecom/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../global_controller/languages_controller.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final box = GetStorage();
  int currentindex = 0;

  PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 1.0,
  );

  int currentSliderindex = 0;

  int selectedIndex = 0;

  Timer? _timer;

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (currentSliderindex <
          sliderController.allsliderlist.value.data!.advertisements.length -
              1) {
        currentSliderindex++;
      } else {
        currentSliderindex = 0;
      }
      _pageController.animateToPage(
        currentSliderindex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {});
    });
  }

  String permission = "yes";

  @override
  void initState() {
    super.initState();
    categorisListController.fetchcategories();
    scrollController.addListener(refresh);

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return; // optional
      setState(() {
        containerHeight = _tabController.index == 0 ? 220.0 : 250.0;
      });
    });
    // _startAutoSlide();
    box.write("orderstatus", "");
  }

  Future<void> bodyrefresh() async {
    // This function is called when the user pulls down the ListView
    print("ListView pulled down!");
    // dashboardController.fetchDashboardData();
    historyController.finalList.clear();
    historyController.initialpage = 1;
    historyController.fetchHistory();

    await Future.delayed(Duration(seconds: 1)); // Simulating a delay
  }

  Future<void> refresh() async {
    final int totalPages =
        historyController.allorderlist.value.payload?.pagination.totalPages ??
        0;
    final int currentPage = historyController.initialpage;

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
      historyController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (historyController.initialpage <= totalPages) {
        print("Load More...................");
        historyController.fetchHistory();
      } else {
        historyController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  final dashboardController = Get.find<DashboardController>();
  final historyController = Get.find<HistoryController>();

  final sliderController = Get.find<SliderController>();
  final countryListController = Get.find<CountryListController>();
  final categorisListController = Get.find<CategorisListController>();

  final serviceController = Get.find<ServiceController>();
  final bundleController = Get.find<BundleController>();

  final languagesController = Get.find<LanguagesController>();

  final BundleController abundleController = Get.put(
    BundleController(),
    permanent: true,
  );

  final ScrollController scrollController = ScrollController();

  late TabController _tabController;
  double containerHeight = 220.0;

  String myversion = "1.0.4";
  var maindata;
  var currentversion;
  String? checknow;

  fetchDate() {
    FirebaseFirestore.instance
        .collection("amutelecom")
        .doc("currentversion")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            maindata = documentSnapshot.data();
            checknow = maindata["permission"];
            currentversion = maindata["version"];

            print(maindata["permission"]);

            print("Current version from database: $currentversion");
            if (checknow == "yes") {
              if (myversion != currentversion) {
                _showUpdateDialog();
              } else {
                print("Not checking permission");
              }
            }
          } else {
            print('Document does not exist on the database');
          }
        })
        .catchError((error) {
          print("Error fetching data: $error");
        });
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(languagesController.tr("UPDATE_AVAILABLE")),
          content: Text(
            "${languagesController.tr("UPDATE_TITLE")} $currentversion.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                _launchURL(
                  "https://play.google.com/store/apps/details?id=com.woosat.amu_update",
                );
              },
              child: Text(languagesController.tr("UPDATE_NOW")),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int selectedFlexIndex = 0;

  List mycolor = [
    Color(0xffCD61EA),
    Color(0xffE06071),
    Color(0xff5DBCAE),
    Color(0xffEA8743),
    Color(0xffCD61EA),
    Color(0xffE06071),
    Color(0xff5DBCAE),
    Color(0xffEA8743),
    Color(0xffCD61EA),
    Color(0xffE06071),
    Color(0xff5DBCAE),
    Color(0xffEA8743),
    Color(0xffCD61EA),
    Color(0xffE06071),
    Color(0xff5DBCAE),
    Color(0xffEA8743),
    Color(0xffCD61EA),
    Color(0xffE06071),
    Color(0xff5DBCAE),
    Color(0xffEA8743),
  ];

  @override
  Widget build(BuildContext context) {
    fetchDate();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Obx(
        () =>
            dashboardController.isLoading.value == false &&
                sliderController.isLoading.value == false
            ? Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  leading: Obx(
                    () => Padding(
                      padding: EdgeInsets.all(6.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade200,
                        child: ClipOval(
                          child:
                              (dashboardController
                                          .alldashboardData
                                          .value
                                          .data
                                          ?.userInfo
                                          ?.profileImageUrl !=
                                      null &&
                                  dashboardController
                                      .alldashboardData
                                      .value
                                      .data!
                                      .userInfo!
                                      .profileImageUrl!
                                      .isNotEmpty &&
                                  dashboardController
                                          .alldashboardData
                                          .value
                                          .data!
                                          .userInfo!
                                          .profileImageUrl!
                                          .toString() !=
                                      "null")
                              ? Image.network(
                                  dashboardController
                                      .alldashboardData
                                      .value
                                      .data!
                                      .userInfo!
                                      .profileImageUrl!
                                      .toString(),
                                  fit: BoxFit.cover,
                                  width: 40,
                                  height: 40,
                                  errorBuilder: (context, error, stackTrace) {
                                    // fallback if 404 or load fails
                                    return Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                      size: 28,
                                    );
                                  },
                                )
                              : Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 28,
                                ),
                        ),
                      ),
                    ),
                  ),
                  elevation: 1.0,
                  backgroundColor: Colors.white,
                  title: Row(
                    children: [
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                fetchDate();
                              },
                              child: Text(
                                dashboardController
                                    .alldashboardData
                                    .value
                                    .data!
                                    .userInfo!
                                    .resellerName
                                    .toString(),
                                style: GoogleFonts.rubik(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              dashboardController
                                  .alldashboardData
                                  .value
                                  .data!
                                  .userInfo!
                                  .phone
                                  .toString(),
                              style: GoogleFonts.rubik(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  languagesController.tr("LANGUAGES"),
                                ),
                                content: SizedBox(
                                  height: 350,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: languagesController
                                        .alllanguagedata
                                        .length,
                                    itemBuilder: (context, index) {
                                      final data = languagesController
                                          .alllanguagedata[index];

                                      return GestureDetector(
                                        onTap: () {
                                          final languageName = data["name"]
                                              .toString();

                                          final matched = languagesController
                                              .alllanguagedata
                                              .firstWhere(
                                                (lang) =>
                                                    lang["name"] ==
                                                    languageName,
                                                orElse: () => {
                                                  "isoCode": "en",
                                                  "direction": "ltr",
                                                },
                                              );

                                          final languageISO =
                                              matched["isoCode"]!;
                                          final languageDirection =
                                              matched["direction"]!;

                                          // Save & apply
                                          languagesController.changeLanguage(
                                            languageName,
                                          );
                                          box.write("language", languageName);
                                          box.write(
                                            "direction",
                                            languageDirection,
                                          );

                                          // Map iso → Locale
                                          Locale locale;
                                          switch (languageISO) {
                                            case "fa":
                                              locale = const Locale("fa", "IR");
                                              break;
                                            case "ar":
                                              locale = const Locale("ar", "AE");
                                              break;
                                            case "ps":
                                              locale = const Locale("ps", "AF");
                                              break;
                                            case "tr":
                                              locale = const Locale("tr", "TR");
                                              break;
                                            case "bn":
                                              locale = const Locale("bn", "BD");
                                              break;
                                            case "en":
                                            default:
                                              locale = const Locale("en", "US");
                                          }

                                          setState(() {
                                            EasyLocalization.of(
                                              context,
                                            )!.setLocale(locale);
                                          });

                                          Navigator.pop(context);
                                          debugPrint(
                                            "🌐 Language: $languageName ($languageISO), dir: $languageDirection",
                                          );
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 5,
                                          ),
                                          height: 45,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: Colors.grey.shade300,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            data["fullname"].toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 45,
                          width: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Obx(
                                () => Text(
                                  languagesController.selectedlan.value,
                                  style: TextStyle(
                                    color: Color(0xff233F78),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.language,
                                color: Colors.black,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         return AlertDialog(
                      //           title: Text(languagesController
                      //               .tr("CHANGE_LANGUAGE")),
                      //           content: Container(
                      //             height: 350,
                      //             width: screenWidth,
                      //             child: ListView.builder(
                      //               shrinkWrap: true,
                      //               itemCount: languagesController
                      //                   .alllanguagedata.length,
                      //               itemBuilder: (context, index) {
                      //                 final data = languagesController
                      //                     .alllanguagedata[index];
                      //                 return GestureDetector(
                      //                   onTap: () {
                      //                     final languageName =
                      //                         data["name"].toString();

                      //                     final matched =
                      //                         languagesController
                      //                             .alllanguagedata
                      //                             .firstWhere(
                      //                       (lang) =>
                      //                           lang["name"] ==
                      //                           languageName,
                      //                       orElse: () => {
                      //                         "isoCode": "en",
                      //                         "direction": "ltr"
                      //                       },
                      //                     );

                      //                     final languageISO =
                      //                         matched["isoCode"]!;
                      //                     final languageDirection =
                      //                         matched["direction"]!;

                      //                     // Store selected language & direction
                      //                     languagesController
                      //                         .changeLanguage(languageName);
                      //                     box.write(
                      //                         "language", languageName);
                      //                     box.write("direction",
                      //                         languageDirection);

                      //                     // Set locale based on ISO
                      //                     Locale locale;
                      //                     switch (languageISO) {
                      //                       case "fa":
                      //                         locale = Locale("fa", "IR");
                      //                         break;
                      //                       case "ar":
                      //                         locale = Locale("ar", "AE");
                      //                         break;
                      //                       case "ps":
                      //                         locale = Locale("ps", "AF");
                      //                         break;
                      //                       case "tr":
                      //                         locale = Locale("tr", "TR");
                      //                         break;
                      //                       case "bn":
                      //                         locale = Locale("bn", "BD");
                      //                         break;
                      //                       case "en":
                      //                       default:
                      //                         locale = Locale("en", "US");
                      //                     }

                      //                     // Set app locale
                      //                     setState(() {
                      //                       EasyLocalization.of(context)!
                      //                           .setLocale(locale);
                      //                     });

                      //                     // Pop dialog
                      //                     Navigator.pop(context);

                      //                     print(
                      //                         "🌐 Language changed to $languageName ($languageISO), Direction: $languageDirection");
                      //                   },
                      //                   child: Container(
                      //                     margin:
                      //                         EdgeInsets.only(bottom: 5),
                      //                     height: 45,
                      //                     width: screenWidth,
                      //                     decoration: BoxDecoration(
                      //                       border: Border.all(
                      //                         width: 1,
                      //                         color: Colors.grey.shade300,
                      //                       ),
                      //                       borderRadius:
                      //                           BorderRadius.circular(8),
                      //                     ),
                      //                     child: Padding(
                      //                       padding:
                      //                           const EdgeInsets.symmetric(
                      //                               horizontal: 10),
                      //                       child: Row(
                      //                         children: [
                      //                           Center(
                      //                             child: Text(
                      //                               languagesController
                      //                                   .alllanguagedata[
                      //                                       index]
                      //                                       ["fullname"]
                      //                                   .toString(),
                      //                             ),
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 );
                      //               },
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //     );
                      //   },
                      //   child: Icon(
                      //     Icons.language,
                      //     color: Colors.grey,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                // drawer: DrawerWidget(),
                key: _scaffoldKey,
                body: Container(
                  color: Colors.white,
                  height: screenHeight,
                  width: screenHeight,
                  child: RefreshIndicator(
                    color: Colors.white, // Change the progress indicator color
                    backgroundColor: Colors.white, // Change background color
                    onRefresh: bodyrefresh,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        Container(
                          height: 180,
                          width: screenWidth,
                          child: Column(
                            children: [
                              Container(
                                height: 180,
                                child: Obx(
                                  () => PageView.builder(
                                    itemCount: sliderController
                                        .allsliderlist
                                        .value
                                        .data!
                                        .advertisements
                                        .length,
                                    physics: BouncingScrollPhysics(),
                                    controller: _pageController,
                                    onPageChanged: (value) {
                                      currentindex = value;
                                      setState(() {});
                                    },
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: screenWidth,
                                        margin: EdgeInsets.all(8),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Image.network(
                                              sliderController
                                                  .allsliderlist
                                                  .value
                                                  .data!
                                                  .advertisements[index]
                                                  .adSliderImageUrl
                                                  .toString(),
                                              fit: BoxFit.fill,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          height: containerHeight,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            // color: Colors.red.shade100,
                            // borderRadius: BorderRadius.circular(10),
                          ),
                          child: Obx(
                            () => dashboardController.isLoading.value == false
                                ? Column(
                                    children: [
                                      TabBar(
                                        labelColor: Colors.black,
                                        unselectedLabelColor: Colors.grey,
                                        controller: _tabController,
                                        indicatorColor: Colors.black,
                                        labelStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        tabs: [
                                          Tab(
                                            text: languagesController.tr(
                                              "FINANCIAL_INQUIRY",
                                            ),
                                          ),
                                          Tab(
                                            text: languagesController.tr(
                                              "SERVICES",
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 0,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(
                                                        0.2,
                                                      ), // shadow color
                                                  spreadRadius:
                                                      2, // spread radius
                                                  blurRadius: 2, // blur radius
                                                  offset: Offset(
                                                    0,
                                                    0,
                                                  ), // changes position of shadow
                                                ),
                                              ],
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: TabBarView(
                                              physics: BouncingScrollPhysics(),
                                              controller: _tabController,
                                              children: [
                                                // First Tab
                                                SizedBox(
                                                  height: 250,
                                                  child: Center(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                        8.0,
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(height: 5),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child: Container(
                                                                  height: 60,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          10,
                                                                        ),
                                                                    color: Color(
                                                                      0xff5F59E1,
                                                                    ),
                                                                  ),
                                                                  child: Stack(
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            60,
                                                                        width:
                                                                            90,
                                                                        decoration: BoxDecoration(
                                                                          color:
                                                                              Colors.white24,
                                                                          borderRadius: const BorderRadius.only(
                                                                            bottomRight: Radius.circular(
                                                                              80,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        right:
                                                                            0,
                                                                        child: Container(
                                                                          height:
                                                                              60,
                                                                          width:
                                                                              60,
                                                                          decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white24,
                                                                            borderRadius: const BorderRadius.only(
                                                                              bottomLeft: Radius.circular(
                                                                                40,
                                                                              ),
                                                                              topLeft: Radius.circular(
                                                                                500,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Center(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                5,
                                                                          ),
                                                                          child: Row(
                                                                            children: [
                                                                              Image.asset(
                                                                                "assets/icons/money.png",
                                                                                height: 40,
                                                                              ),
                                                                              SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    languagesController.tr(
                                                                                      "BALANCE",
                                                                                    ),
                                                                                    style: TextStyle(
                                                                                      fontSize: 14,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 3,
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        NumberFormat.currency(
                                                                                          locale: 'en_US',
                                                                                          symbol: '',
                                                                                          decimalDigits: 2,
                                                                                        ).format(
                                                                                          double.parse(
                                                                                            dashboardController.alldashboardData.value.data!.balance.toString(),
                                                                                          ),
                                                                                        ),
                                                                                        style: TextStyle(
                                                                                          fontSize: 12,
                                                                                          fontWeight: FontWeight.w800,
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 5,
                                                                                      ),
                                                                                      Text(
                                                                                        "${box.read("currency_code")}",
                                                                                        style: TextStyle(
                                                                                          fontSize: 10,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Container(
                                                                  height: 60,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          10,
                                                                        ),
                                                                    color: Color(
                                                                      0xff499E79,
                                                                    ),
                                                                  ),
                                                                  child: Stack(
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            60,
                                                                        width:
                                                                            90,
                                                                        decoration: BoxDecoration(
                                                                          color:
                                                                              Colors.white24,
                                                                          borderRadius: const BorderRadius.only(
                                                                            bottomRight: Radius.circular(
                                                                              80,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        right:
                                                                            0,
                                                                        child: Container(
                                                                          height:
                                                                              60,
                                                                          width:
                                                                              60,
                                                                          decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white24,
                                                                            borderRadius: const BorderRadius.only(
                                                                              bottomLeft: Radius.circular(
                                                                                40,
                                                                              ),
                                                                              topLeft: Radius.circular(
                                                                                500,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Center(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                5,
                                                                          ),
                                                                          child: Row(
                                                                            children: [
                                                                              Image.asset(
                                                                                "assets/icons/money.png",
                                                                                height: 40,
                                                                              ),
                                                                              SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    languagesController.tr(
                                                                                      "LOAN_BALANCE",
                                                                                    ),
                                                                                    style: TextStyle(
                                                                                      fontSize: 14,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 3,
                                                                                  ),
                                                                                  Row(
                                                                                    // mainAxisAlignment:
                                                                                    //     MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Text(
                                                                                        NumberFormat.currency(
                                                                                          locale: 'en_US',
                                                                                          symbol: '',
                                                                                          decimalDigits: 2,
                                                                                        ).format(
                                                                                          double.parse(
                                                                                            dashboardController.alldashboardData.value.data!.loanBalance.toString(),
                                                                                          ),
                                                                                        ),
                                                                                        style: TextStyle(
                                                                                          fontSize: 12,
                                                                                          fontWeight: FontWeight.w800,
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 7,
                                                                                      ),
                                                                                      Text(
                                                                                        "${box.read("currency_code")}",
                                                                                        style: TextStyle(
                                                                                          fontSize: 10,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Container(
                                                            height: 60,
                                                            width: screenWidth,
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  flex:
                                                                      selectedFlexIndex ==
                                                                          0
                                                                      ? 3
                                                                      : 1,
                                                                  child: GestureDetector(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        selectedFlexIndex =
                                                                            0; // Set this container to active
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                      child: Center(
                                                                        child:
                                                                            selectedFlexIndex ==
                                                                                0
                                                                            ? _buildFullStack(
                                                                                selectedFlexIndex ==
                                                                                        0
                                                                                    ? Colors.red
                                                                                    : Colors.red,
                                                                                languagesController.tr(
                                                                                  "TODAY_SALE",
                                                                                ),
                                                                                NumberFormat.currency(
                                                                                  locale: 'en_US',
                                                                                  symbol: '',
                                                                                  decimalDigits: 2,
                                                                                ).format(
                                                                                  double.parse(
                                                                                    dashboardController.alldashboardData.value.data!.todaySale.toString(),
                                                                                  ),
                                                                                ),
                                                                              ) // Show full Stack design
                                                                            : _buildSimpleStack(
                                                                                selectedFlexIndex ==
                                                                                        0
                                                                                    ? Colors.red
                                                                                    : Colors.red,
                                                                              ), // Show reduced Stack design
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Expanded(
                                                                  flex:
                                                                      selectedFlexIndex ==
                                                                          1
                                                                      ? 3
                                                                      : 1,
                                                                  child: GestureDetector(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        selectedFlexIndex =
                                                                            1; // Set this container to active
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                      child: Center(
                                                                        child:
                                                                            selectedFlexIndex ==
                                                                                1
                                                                            ? _buildFullStack(
                                                                                selectedFlexIndex ==
                                                                                        0
                                                                                    ? Color(
                                                                                        0xff0ffD48836,
                                                                                      )
                                                                                    : Color(
                                                                                        0xff0ffD48836,
                                                                                      ),
                                                                                languagesController.tr(
                                                                                  "TOTAL_SALE",
                                                                                ),
                                                                                NumberFormat.currency(
                                                                                  locale: 'en_US',
                                                                                  symbol: '',
                                                                                  decimalDigits: 2,
                                                                                ).format(
                                                                                  double.parse(
                                                                                    dashboardController.alldashboardData.value.data!.totalSoldAmount.toString(),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : _buildSimpleStack(
                                                                                Color(
                                                                                  0xffD48836,
                                                                                ),
                                                                              ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Expanded(
                                                                  flex:
                                                                      selectedFlexIndex ==
                                                                          2
                                                                      ? 3
                                                                      : 1,
                                                                  child: GestureDetector(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        selectedFlexIndex =
                                                                            2; // Set this container to active
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                      child: Center(
                                                                        child:
                                                                            selectedFlexIndex ==
                                                                                2
                                                                            ? _buildFullStack(
                                                                                selectedFlexIndex ==
                                                                                        0
                                                                                    ? Colors.purple
                                                                                    : Colors.purple,
                                                                                languagesController.tr(
                                                                                  "TODAY_PROFIT",
                                                                                ),
                                                                                NumberFormat.currency(
                                                                                  locale: 'en_US',
                                                                                  symbol: '',
                                                                                  decimalDigits: 2,
                                                                                ).format(
                                                                                  double.parse(
                                                                                    dashboardController.alldashboardData.value.data!.todayProfit.toString(),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : _buildSimpleStack(
                                                                                Colors.purple,
                                                                              ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Expanded(
                                                                  flex:
                                                                      selectedFlexIndex ==
                                                                          3
                                                                      ? 3
                                                                      : 1,
                                                                  child: GestureDetector(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        selectedFlexIndex =
                                                                            3; // Set this container to active
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                      child: Center(
                                                                        child:
                                                                            selectedFlexIndex ==
                                                                                3
                                                                            ? _buildFullStack(
                                                                                selectedFlexIndex ==
                                                                                        0
                                                                                    ? Colors.green
                                                                                    : Colors.green,
                                                                                languagesController.tr(
                                                                                  "TOTAL_PROFIT",
                                                                                ),
                                                                                NumberFormat.currency(
                                                                                  locale: 'en_US',
                                                                                  symbol: '',
                                                                                  decimalDigits: 2,
                                                                                ).format(
                                                                                  double.parse(
                                                                                    dashboardController.alldashboardData.value.data!.totalRevenue.toString(),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : _buildSimpleStack(
                                                                                Colors.green,
                                                                              ),
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
                                                  ),
                                                ),
                                                // 2nd Tab
                                                SizedBox(
                                                  height: 250,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Obx(
                                                          () =>
                                                              countryListController
                                                                      .isLoading
                                                                      .value ==
                                                                  false
                                                              ? Container(
                                                                  margin:
                                                                      EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            5,
                                                                      ),
                                                                  height: 35,
                                                                  width:
                                                                      screenWidth,
                                                                  // color: Colors.grey,
                                                                  child: ListView.separated(
                                                                    physics:
                                                                        BouncingScrollPhysics(),
                                                                    separatorBuilder:
                                                                        (
                                                                          context,
                                                                          index,
                                                                        ) {
                                                                          return SizedBox(
                                                                            width:
                                                                                10,
                                                                          );
                                                                        },
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    itemCount: countryListController
                                                                        .allcountryListData
                                                                        .value
                                                                        .data!
                                                                        .countries
                                                                        .length,
                                                                    itemBuilder:
                                                                        (
                                                                          context,
                                                                          index,
                                                                        ) {
                                                                          final data = countryListController
                                                                              .allcountryListData
                                                                              .value
                                                                              .data!
                                                                              .countries[index];
                                                                          bool
                                                                          isSelected =
                                                                              index ==
                                                                              selectedIndex;
                                                                          return GestureDetector(
                                                                            onTap: () {
                                                                              setState(
                                                                                () {
                                                                                  selectedIndex = index;

                                                                                  box.write(
                                                                                    "country_id",
                                                                                    data.id,
                                                                                  );
                                                                                  print(
                                                                                    box.read(
                                                                                      "country_id",
                                                                                    ),
                                                                                  );
                                                                                  box.write(
                                                                                    "maxlength",
                                                                                    data.phoneNumberLength.toString(),
                                                                                  );
                                                                                  print(
                                                                                    box.read(
                                                                                      "maxlength",
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                color: isSelected
                                                                                    ? Color(
                                                                                        0xff275332,
                                                                                      )
                                                                                    : Colors.grey.shade100,
                                                                                borderRadius: BorderRadius.circular(
                                                                                  15,
                                                                                ),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: EdgeInsets.symmetric(
                                                                                  horizontal: 10,
                                                                                  vertical: 5,
                                                                                ),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Container(
                                                                                      height: 30,
                                                                                      width: 30,
                                                                                      decoration: BoxDecoration(
                                                                                        image: DecorationImage(
                                                                                          fit: BoxFit.fill,
                                                                                          image: NetworkImage(
                                                                                            data.countryFlagImageUrl.toString(),
                                                                                          ),
                                                                                        ),
                                                                                        shape: BoxShape.circle,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 8,
                                                                                    ),
                                                                                    Text(
                                                                                      data.countryName.toString(),
                                                                                      style: TextStyle(
                                                                                        color: isSelected
                                                                                            ? Colors.white
                                                                                            : Colors.black,
                                                                                        fontSize: 14,
                                                                                        fontWeight: FontWeight.w500,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                  ),
                                                                )
                                                              : SizedBox(),
                                                        ),
                                                        Obx(
                                                          () =>
                                                              categorisListController
                                                                      .isLoading
                                                                      .value ==
                                                                  false
                                                              ? Container(
                                                                  color: Colors
                                                                      .white,
                                                                  width:
                                                                      screenWidth,
                                                                  height: 140,
                                                                  child: Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                          5.0,
                                                                        ),
                                                                    child: GridView.builder(
                                                                      physics:
                                                                          BouncingScrollPhysics(),
                                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                        crossAxisCount:
                                                                            2,
                                                                        crossAxisSpacing:
                                                                            5.0,
                                                                        mainAxisSpacing:
                                                                            5.0,
                                                                        childAspectRatio:
                                                                            2.7,
                                                                      ),
                                                                      itemCount: categorisListController
                                                                          .allcategorieslist
                                                                          .value!
                                                                          .data!
                                                                          .servicecategories!
                                                                          .length,
                                                                      itemBuilder:
                                                                          (
                                                                            context,
                                                                            index,
                                                                          ) {
                                                                            final data =
                                                                                categorisListController.allcategorieslist.value!.data!.servicecategories![index];

                                                                            return GestureDetector(
                                                                              onTap: () {
                                                                                box.write(
                                                                                  "service_category_id",
                                                                                  data.id,
                                                                                );
                                                                                // box.write("service_id", "");
                                                                                box.write(
                                                                                  "validity_type",
                                                                                  "",
                                                                                );
                                                                                box.write(
                                                                                  "company_id",
                                                                                  "",
                                                                                );
                                                                                box.write(
                                                                                  "search_tag",
                                                                                  "",
                                                                                );

                                                                                if (data.type ==
                                                                                    "social") {
                                                                                  // box.write(
                                                                                  //     "country_id",
                                                                                  //     "");
                                                                                  Get.toNamed(
                                                                                    socialrechargescreen,
                                                                                  );

                                                                                  bundleController.finalList.clear();
                                                                                  bundleController.initialpage = 1;
                                                                                  serviceController.fetchservices();
                                                                                  bundleController.fetchallbundles();
                                                                                } else {
                                                                                  print(
                                                                                    box.read(
                                                                                      "country_id",
                                                                                    ),
                                                                                  );

                                                                                  bundleController.finalList.clear();
                                                                                  bundleController.initialpage = 1;
                                                                                  bundleController.fetchallbundles();
                                                                                  serviceController.fetchservices();

                                                                                  Get.toNamed(
                                                                                    rechargescreen,
                                                                                  );

                                                                                  // Navigator
                                                                                  //     .push(
                                                                                  //   context,
                                                                                  //   MaterialPageRoute(
                                                                                  //     builder: (context) => RechargeScreen(),
                                                                                  //   ),
                                                                                  // );
                                                                                }
                                                                              },
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(
                                                                                    10,
                                                                                  ),
                                                                                  color: mycolor[index],
                                                                                ),
                                                                                child: Stack(
                                                                                  children: [
                                                                                    Container(
                                                                                      height: 70,
                                                                                      width: 90,
                                                                                      decoration: BoxDecoration(
                                                                                        color: Colors.white10,
                                                                                        borderRadius: const BorderRadius.only(
                                                                                          bottomRight: Radius.circular(
                                                                                            80,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Positioned(
                                                                                      right: 0,
                                                                                      child: Container(
                                                                                        height: 70,
                                                                                        width: 40,
                                                                                        decoration: BoxDecoration(
                                                                                          color: Colors.white10,
                                                                                          borderRadius: const BorderRadius.only(
                                                                                            bottomLeft: Radius.circular(
                                                                                              50,
                                                                                            ),
                                                                                            topLeft: Radius.circular(
                                                                                              500,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Center(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.symmetric(
                                                                                          horizontal: 5,
                                                                                        ),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: [
                                                                                            Text(
                                                                                              data.categoryName.toString(),
                                                                                              style: TextStyle(
                                                                                                color: Colors.white,
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.w600,
                                                                                              ),
                                                                                            ),
                                                                                          ],
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
                                                                )
                                                              : SizedBox(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                        ),
                        //............................................Custom Recharge.........................//
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            if (countryListController
                                .finalCountryList
                                .isNotEmpty) {
                              // Find the country where the name is "Afghanistan"
                              var afghanistan = countryListController
                                  .finalCountryList
                                  .firstWhere(
                                    (country) =>
                                        country['country_name'] ==
                                        "Afghanistan",
                                    orElse: () =>
                                        null, // Return null if not found
                                  );

                              if (afghanistan != null) {
                                print(
                                  "The ID for Afghanistan is: ${afghanistan['id']}",
                                );
                                box.write("country_id", "${afghanistan['id']}");
                                box.write("maxlength", "10");
                              } else {
                                print("Afghanistan not found in the list");
                              }
                            } else {
                              print("Country list is empty.");
                            }

                            Get.toNamed(customrechargescreen);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Container(
                              width: screenWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.defaultColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Center(
                                  child: Text(
                                    languagesController.tr("CUSTOM_RECHARGE"),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(height: 10),
                        historyController.isLoading.value == false
                            ? Container(
                                height: 350,
                                // color: Colors.red,
                                width: screenWidth,
                                child: Obx(
                                  () =>
                                      historyController.isLoading.value ==
                                              false &&
                                          historyController.finalList.isNotEmpty
                                      ? RefreshIndicator(
                                          onRefresh: refresh,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 0,
                                            ),
                                            child: ListView.separated(
                                              shrinkWrap: false,
                                              physics:
                                                  AlwaysScrollableScrollPhysics(),
                                              controller: scrollController,
                                              separatorBuilder:
                                                  (context, index) {
                                                    return SizedBox(height: 5);
                                                  },
                                              itemCount: historyController
                                                  .finalList
                                                  .length,
                                              itemBuilder: (context, index) {
                                                final data = historyController
                                                    .finalList[index];
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => OrderDetailsScreen(
                                                          createDate: data
                                                              .createdAt
                                                              .toString(),
                                                          status: data.status
                                                              .toString(),
                                                          rejectReason: data
                                                              .rejectReason
                                                              .toString(),
                                                          companyName: data
                                                              .bundle!
                                                              .service!
                                                              .company!
                                                              .companyName
                                                              .toString(),
                                                          bundleTitle: data
                                                              .bundle!
                                                              .bundleTitle!
                                                              .toString(),
                                                          rechargebleAccount: data
                                                              .rechargebleAccount!
                                                              .toString(),
                                                          validityType: data
                                                              .bundle!
                                                              .validityType!
                                                              .toString(),
                                                          sellingPrice: data
                                                              .bundle!
                                                              .sellingPrice
                                                              .toString(),
                                                          orderID: data.id!
                                                              .toString(),
                                                          contactName:
                                                              dashboardController
                                                                  .alldashboardData
                                                                  .value
                                                                  .data!
                                                                  .userInfo!
                                                                  .contactName
                                                                  .toString(),
                                                          resellerPhone:
                                                              dashboardController
                                                                  .alldashboardData
                                                                  .value
                                                                  .data!
                                                                  .userInfo!
                                                                  .phone
                                                                  .toString(),
                                                          companyLogo: data
                                                              .bundle!
                                                              .service!
                                                              .company!
                                                              .companyLogo
                                                              .toString(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                      top: 5,
                                                      right: 3,
                                                      left: 3,
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
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            5.0,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            height: 40,
                                                            width: 40,
                                                            decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                fit:
                                                                    BoxFit.fill,
                                                                image: CachedNetworkImageProvider(
                                                                  data
                                                                      .bundle!
                                                                      .service!
                                                                      .company!
                                                                      .companyLogo
                                                                      .toString(),
                                                                ),
                                                              ),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                    left: 5,
                                                                  ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                      data
                                                                          .bundle!
                                                                          .bundleTitle
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    data.rechargebleAccount
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  NumberFormat.currency(
                                                                    locale:
                                                                        'en_US',
                                                                    symbol: '',
                                                                    decimalDigits:
                                                                        2,
                                                                  ).format(
                                                                    double.parse(
                                                                      data
                                                                          .bundle!
                                                                          .sellingPrice
                                                                          .toString(),
                                                                    ),
                                                                  ),
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Text(
                                                                  " " +
                                                                      box.read(
                                                                        "currency_code",
                                                                      ),
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  // Icon(
                                                                  //   Icons.check,
                                                                  //   color: Colors.green,
                                                                  //   size: 14,
                                                                  // ),
                                                                  Image.asset(
                                                                    data.status.toString() ==
                                                                            "0"
                                                                        ? "assets/icons/pending.png"
                                                                        : data.status.toString() ==
                                                                              "1"
                                                                        ? "assets/icons/success.png"
                                                                        : "assets/icons/reject.png",
                                                                    height: 30,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      : historyController.finalList.isEmpty
                                      ? SizedBox()
                                      : RefreshIndicator(
                                          onRefresh: refresh,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 0,
                                            ),
                                            child: ListView.separated(
                                              shrinkWrap: false,
                                              physics:
                                                  AlwaysScrollableScrollPhysics(),
                                              controller: scrollController,
                                              separatorBuilder:
                                                  (context, index) {
                                                    return SizedBox(height: 5);
                                                  },
                                              itemCount: historyController
                                                  .finalList
                                                  .length,
                                              itemBuilder: (context, index) {
                                                final data = historyController
                                                    .finalList[index];
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => OrderDetailsScreen(
                                                          createDate: data
                                                              .createdAt
                                                              .toString(),
                                                          status: data.status
                                                              .toString(),
                                                          rejectReason: data
                                                              .rejectReason
                                                              .toString(),
                                                          companyName: data
                                                              .bundle!
                                                              .service!
                                                              .company!
                                                              .companyName
                                                              .toString(),
                                                          bundleTitle: data
                                                              .bundle!
                                                              .bundleTitle!
                                                              .toString(),
                                                          rechargebleAccount: data
                                                              .rechargebleAccount!
                                                              .toString(),
                                                          validityType: data
                                                              .bundle!
                                                              .validityType!
                                                              .toString(),
                                                          sellingPrice: data
                                                              .bundle!
                                                              .sellingPrice
                                                              .toString(),
                                                          orderID: data.id!
                                                              .toString(),
                                                          contactName:
                                                              dashboardController
                                                                  .alldashboardData
                                                                  .value
                                                                  .data!
                                                                  .userInfo!
                                                                  .contactName
                                                                  .toString(),
                                                          resellerPhone:
                                                              dashboardController
                                                                  .alldashboardData
                                                                  .value
                                                                  .data!
                                                                  .userInfo!
                                                                  .phone
                                                                  .toString(),
                                                          companyLogo: data
                                                              .bundle!
                                                              .service!
                                                              .company!
                                                              .companyLogo
                                                              .toString(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                      top: 5,
                                                      right: 3,
                                                      left: 3,
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
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            5.0,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            height: 40,
                                                            width: 40,
                                                            decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                fit:
                                                                    BoxFit.fill,
                                                                image: CachedNetworkImageProvider(
                                                                  data
                                                                      .bundle!
                                                                      .service!
                                                                      .company!
                                                                      .companyLogo
                                                                      .toString(),
                                                                ),
                                                              ),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                    left: 5,
                                                                  ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                      data
                                                                          .bundle!
                                                                          .bundleTitle
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    data.rechargebleAccount
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  NumberFormat.currency(
                                                                    locale:
                                                                        'en_US',
                                                                    symbol: '',
                                                                    decimalDigits:
                                                                        2,
                                                                  ).format(
                                                                    double.parse(
                                                                      data
                                                                          .bundle!
                                                                          .sellingPrice
                                                                          .toString(),
                                                                    ),
                                                                  ),
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Text(
                                                                  " " +
                                                                      box.read(
                                                                        "currency_code",
                                                                      ),
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  // Icon(
                                                                  //   Icons.check,
                                                                  //   color: Colors.green,
                                                                  //   size: 14,
                                                                  // ),
                                                                  Image.asset(
                                                                    data.status.toString() ==
                                                                            "0"
                                                                        ? "assets/icons/pending.png"
                                                                        : data.status.toString() ==
                                                                              "1"
                                                                        ? "assets/icons/success.png"
                                                                        : "assets/icons/reject.png",
                                                                    height: 30,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  color: Colors.grey,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              )
            : Scaffold(
                body: Center(
                  child: CircularProgressIndicator(color: Colors.grey),
                ),
              ),
      ),
    );
  }
}

Widget _buildFullStack(Color color, String balanceName, String amount) {
  final box = GetStorage();
  return Container(
    height: 60,
    width: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: color,
    ),
    child: Stack(
      children: [
        Container(
          height: 60,
          width: 90,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(80),
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                topLeft: Radius.circular(500),
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Image.asset("assets/icons/money.png", height: 40),
                SizedBox(width: 5),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      balanceName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          amount,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "${box.read("currency_code")}",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// Simple Stack Design (Without the first container)
Widget _buildSimpleStack(Color color) {
  return Container(
    height: 60,
    width: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: color,
    ),
    child: Stack(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              topLeft: Radius.circular(900),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/icons/money.png"),
            ),
          ),
        ),
      ],
    ),
  );
}

import 'dart:async';
import 'package:amutelecom/controllers/dashboard_controller.dart';
import 'package:amutelecom/global_controller/languages_controller.dart';
import 'package:amutelecom/helpers/capture_image_helper.dart';

import 'package:amutelecom/helpers/localtime_helper.dart';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:intl/intl.dart';

import 'package:amutelecom/controllers/order_list_controller.dart';
import 'package:amutelecom/screens/order_details.dart';
import 'package:amutelecom/utils/colors.dart';

import 'package:dotted_line/dotted_line.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final ScrollController scrollController = ScrollController();
  late LanguagesController languagesController;

  List orderStatus = [];

  @override
  void initState() {
    super.initState();
    box.write("search_target", "");
    box.write("orderstatus", "");
    languagesController = Get.put(LanguagesController());

    orderStatus = [
      {"title": languagesController.tr("PENDING"), "value": "order_status=0"},
      {"title": languagesController.tr("CONFIRMED"), "value": "order_status=1"},
      {"title": languagesController.tr("REJECTED"), "value": "order_status=2"},
    ];

    orderlistController.finalList.clear();
    orderlistController.fetchOrderlistdata();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        orderlistController.fetchMore();
      }
    });
  }

  final box = GetStorage();

  bool isvisible = false;

  String defaultValue = "";
  String secondDropDown = "";

  TextEditingController searchController = TextEditingController();

  String search = "";

  final dashboardController = Get.find<DashboardController>();
  final orderlistController = Get.find<OrderlistController>();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.grey),
        ),
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          languagesController.tr("ORDERS"),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(),
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: AppColors.defaultColor,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            onChanged: (value) {
                              orderlistController.finalList.clear();
                              orderlistController.currentPage = 1;
                              box.write("search_target", value.toString());
                              orderlistController.fetchOrderlistdata();
                              print(value.toString());
                            },
                            controller: searchController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: languagesController.tr(
                                "ENTER_YOUR_NUMBER",
                              ),
                              hintStyle: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isvisible = !isvisible;
                        print(isvisible);
                      });
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        // color: Color(0xff46558A),
                        color: AppColors.defaultColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Text(
                              languagesController.tr("FILTER"),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              FontAwesomeIcons.filter,
                              color: Colors.white,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0),
              Visibility(
                visible: isvisible,
                child: Container(
                  height: 120,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    // border: Border.all(
                    //     width: 1,
                    //     color: Colors.grey), // color: Colors.black12,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(languagesController.tr("ORDER_STATUS")),
                                Container(
                                  height: 40,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        isDense: true,
                                        value: defaultValue,
                                        isExpanded: true,
                                        items: [
                                          DropdownMenuItem(
                                            value: "",
                                            child: Text(
                                              languagesController.tr(
                                                "SELECT_STATUS",
                                              ),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                          ...orderStatus
                                              .map<DropdownMenuItem<String>>((
                                                data,
                                              ) {
                                                return DropdownMenuItem(
                                                  value: data['value'],
                                                  child: Text(data['title']),
                                                );
                                              })
                                              .toList(),
                                        ],
                                        onChanged: (value) {
                                          box.write("orderstatus", value);
                                          // print(
                                          //     "selected Value $value");
                                          setState(() {
                                            defaultValue = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(languagesController.tr("SELECTED_DATE")),
                                Container(
                                  height: 30,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            languagesController.tr(
                                              "SELECTED_DATE",
                                            ),
                                          ),
                                        ),
                                        Icon(Icons.arrow_downward),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  orderlistController.currentPage = 1;
                                  orderlistController.finalList.clear();
                                  orderlistController.fetchOrderlistdata();
                                  print(box.read("orderstatus"));
                                },
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: AppColors.defaultColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    child: Center(
                                      child: Text(
                                        languagesController.tr("APPLY_FILTER"),
                                        style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  box.write("orderstatus", "");

                                  orderlistController.currentPage = 1;
                                  orderlistController.finalList.clear();

                                  orderlistController.fetchOrderlistdata();

                                  defaultValue = "";
                                  setState(() {
                                    isvisible = !isvisible;
                                  });
                                },
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: AppColors.defaultColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    child: Center(
                                      child: Text(
                                        languagesController.tr("CLEAR_FILTERS"),
                                        style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
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

              SizedBox(height: 15),
              Obx(
                () => orderlistController.isLoading.value == true
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
              Obx(
                () => orderlistController.isLoading.value == false
                    ? Container(
                        child:
                            orderlistController
                                .allorderlist
                                .value
                                .data!
                                .orders
                                .isNotEmpty
                            ? SizedBox()
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/empty.png",
                                      height: 80,
                                    ),
                                    Text("No Data found", style: TextStyle()),
                                  ],
                                ),
                              ),
                      )
                    : SizedBox(),
              ),
              Expanded(
                child: Obx(
                  () =>
                      orderlistController.isLoading.value == false &&
                          orderlistController.finalList.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: () async {
                            await orderlistController.fetchOrderlistdata();
                          },
                          child: ListView.builder(
                            shrinkWrap: false,
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: scrollController,
                            itemCount: orderlistController.finalList.length,
                            itemBuilder: (context, index) {
                              final data = orderlistController.finalList[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderDetailsScreen(
                                        createDate: data.createdAt.toString(),
                                        status: data.status.toString(),
                                        rejectReason: data.rejectReason
                                            .toString(),
                                        companyName: data
                                            .bundle!
                                            .service!
                                            .company!
                                            .companyName
                                            .toString(),
                                        bundleTitle: data.bundle!.bundleTitle!
                                            .toString(),
                                        rechargebleAccount: data
                                            .rechargebleAccount!
                                            .toString(),
                                        validityType: data.bundle!.validityType!
                                            .toString(),
                                        sellingPrice: data.bundle!.sellingPrice
                                            .toString(),
                                        orderID: data.id!.toString(),
                                        contactName: dashboardController
                                            .alldashboardData
                                            .value
                                            .data!
                                            .userInfo!
                                            .contactName
                                            .toString(),
                                        resellerPhone: dashboardController
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
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 1,
                                    vertical: 5,
                                  ),
                                  child: Container(
                                    height: 200,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(
                                            0.2,
                                          ), // shadow color
                                          spreadRadius: 2, // spread radius
                                          blurRadius: 2, // blur radius
                                          offset: Offset(
                                            0,
                                            0,
                                          ), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 60,
                                          width: screenWidth,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            color: Color(0xffE5E9F2),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                25,
                                                              ),
                                                        ),
                                                    color: Colors.white,
                                                  ),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          DateFormat(
                                                            'dd',
                                                          ).format(
                                                            DateTime.parse(
                                                              data.createdAt
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          DateFormat(
                                                            'MMM',
                                                          ).format(
                                                            DateTime.parse(
                                                              data.createdAt
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  languagesController.tr(
                                                        "ORDER_ID",
                                                      ) +
                                                      " ",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  "#${data.id} ",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              // color: Colors.cyan,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(
                                                  10,
                                                ),
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  right: -30,
                                                  bottom: -30,
                                                  child: Container(
                                                    height: 120,
                                                    width: 120,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(
                                                        0xffFAEFF5,
                                                      ).withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            languagesController.tr(
                                                              "RECHARGEABLE_ACCOUNT",
                                                            ),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          // Icon(
                                                          //   Icons.check,
                                                          //   color: Colors.green,
                                                          // ),
                                                          Container(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                    left: 25,
                                                                    top: 5,
                                                                    bottom: 5,
                                                                    right: 5,
                                                                  ),
                                                              child: Text(
                                                                data.status
                                                                            .toString() ==
                                                                        "0"
                                                                    ? languagesController.tr(
                                                                        "PENDING",
                                                                      )
                                                                    : data.status
                                                                              .toString() ==
                                                                          "1"
                                                                    ? languagesController.tr(
                                                                        "CONFIRMED",
                                                                      )
                                                                    : languagesController.tr(
                                                                        "REJECTED",
                                                                      ),
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  color:
                                                                      data.status
                                                                              .toString() ==
                                                                          "0"
                                                                      ? Colors
                                                                            .grey
                                                                      : data.status.toString() ==
                                                                            "1"
                                                                      ? Colors
                                                                            .green
                                                                      : Colors
                                                                            .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            data.rechargebleAccount
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 8),
                                                      Container(
                                                        height: 52,
                                                        width: screenWidth,
                                                        // color: Colors.red,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 10,
                                                              ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      languagesController.tr(
                                                                        "TITLE",
                                                                      ),
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      data
                                                                          .bundle!
                                                                          .bundleTitle
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          languagesController.tr(
                                                                            "SELL",
                                                                          ),
                                                                          style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                          box.read(
                                                                            "currency_code",
                                                                          ),
                                                                          style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.grey,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          NumberFormat.currency(
                                                                            locale:
                                                                                'en_US',
                                                                            symbol:
                                                                                '',
                                                                            decimalDigits:
                                                                                2,
                                                                          ).format(
                                                                            double.parse(
                                                                              data.bundle!.sellingPrice.toString(),
                                                                            ),
                                                                          ),
                                                                          style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      languagesController
                                                                          .tr(
                                                                            "BUY",
                                                                          ),
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                          box.read(
                                                                            "currency_code",
                                                                          ),
                                                                          style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.grey,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          NumberFormat.currency(
                                                                            locale:
                                                                                'en_US',
                                                                            symbol:
                                                                                '',
                                                                            decimalDigits:
                                                                                2,
                                                                          ).format(
                                                                            double.parse(
                                                                              data.bundle!.buyingPrice.toString(),
                                                                            ),
                                                                          ),
                                                                          style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            data
                                                                .bundle!
                                                                .validityType
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          // convertToLocalTime(
                                                          //   data.createdAt
                                                          //       .toString(),
                                                          // )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
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
                        )
                      : orderlistController.finalList.isEmpty
                      ? SizedBox()
                      : RefreshIndicator(
                          onRefresh: () async {
                            await orderlistController.fetchOrderlistdata();
                          },
                          child: ListView.builder(
                            shrinkWrap: false,
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: scrollController,
                            itemCount: orderlistController.finalList.length,
                            itemBuilder: (context, index) {
                              final data = orderlistController.finalList[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderDetailsScreen(
                                        createDate: data.createdAt.toString(),
                                        status: data.status.toString(),
                                        rejectReason: data.rejectReason
                                            .toString(),
                                        companyName: data
                                            .bundle!
                                            .service!
                                            .company!
                                            .companyName
                                            .toString(),
                                        bundleTitle: data.bundle!.bundleTitle!
                                            .toString(),
                                        rechargebleAccount: data
                                            .rechargebleAccount!
                                            .toString(),
                                        validityType: data.bundle!.validityType!
                                            .toString(),
                                        sellingPrice: data.bundle!.sellingPrice
                                            .toString(),
                                        orderID: data.id!.toString(),
                                        contactName: dashboardController
                                            .alldashboardData
                                            .value
                                            .data!
                                            .userInfo!
                                            .contactName
                                            .toString(),
                                        resellerPhone: dashboardController
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
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 1,
                                    vertical: 5,
                                  ),
                                  child: Container(
                                    height: 200,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(
                                            0.2,
                                          ), // shadow color
                                          spreadRadius: 2, // spread radius
                                          blurRadius: 2, // blur radius
                                          offset: Offset(
                                            0,
                                            0,
                                          ), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 60,
                                          width: screenWidth,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            color: Color(0xffE5E9F2),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                25,
                                                              ),
                                                        ),
                                                    color: Colors.white,
                                                  ),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          DateFormat(
                                                            'dd',
                                                          ).format(
                                                            DateTime.parse(
                                                              data.createdAt
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          DateFormat(
                                                            'MMM',
                                                          ).format(
                                                            DateTime.parse(
                                                              data.createdAt
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  languagesController.tr(
                                                        "ORDER_ID",
                                                      ) +
                                                      " ",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  "#${data.id} ",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              // color: Colors.cyan,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(
                                                  10,
                                                ),
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  right: -30,
                                                  bottom: -30,
                                                  child: Container(
                                                    height: 120,
                                                    width: 120,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(
                                                        0xffFAEFF5,
                                                      ).withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            languagesController.tr(
                                                              "RECHARGEABLE_ACCOUNT",
                                                            ),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          // Icon(
                                                          //   Icons.check,
                                                          //   color: Colors.green,
                                                          // ),
                                                          Container(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                    left: 25,
                                                                    top: 5,
                                                                    bottom: 5,
                                                                    right: 5,
                                                                  ),
                                                              child: Text(
                                                                data.status
                                                                            .toString() ==
                                                                        "0"
                                                                    ? languagesController.tr(
                                                                        "PENDING",
                                                                      )
                                                                    : data.status
                                                                              .toString() ==
                                                                          "1"
                                                                    ? languagesController.tr(
                                                                        "CONFIRMED",
                                                                      )
                                                                    : languagesController.tr(
                                                                        "REJECTED",
                                                                      ),
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  color:
                                                                      data.status
                                                                              .toString() ==
                                                                          "0"
                                                                      ? Colors
                                                                            .grey
                                                                      : data.status.toString() ==
                                                                            "1"
                                                                      ? Colors
                                                                            .green
                                                                      : Colors
                                                                            .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            data.rechargebleAccount
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 8),
                                                      Container(
                                                        height: 52,
                                                        width: screenWidth,
                                                        // color: Colors.red,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 10,
                                                              ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      languagesController.tr(
                                                                        "TITLE",
                                                                      ),
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      data
                                                                          .bundle!
                                                                          .bundleTitle
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          languagesController.tr(
                                                                            "SELL",
                                                                          ),
                                                                          style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                          box.read(
                                                                            "currency_code",
                                                                          ),
                                                                          style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.grey,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          NumberFormat.currency(
                                                                            locale:
                                                                                'en_US',
                                                                            symbol:
                                                                                '',
                                                                            decimalDigits:
                                                                                2,
                                                                          ).format(
                                                                            double.parse(
                                                                              data.bundle!.sellingPrice.toString(),
                                                                            ),
                                                                          ),
                                                                          style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      languagesController
                                                                          .tr(
                                                                            "BUY",
                                                                          ),
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                          box.read(
                                                                            "currency_code",
                                                                          ),
                                                                          style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.grey,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          NumberFormat.currency(
                                                                            locale:
                                                                                'en_US',
                                                                            symbol:
                                                                                '',
                                                                            decimalDigits:
                                                                                2,
                                                                          ).format(
                                                                            double.parse(
                                                                              data.bundle!.buyingPrice.toString(),
                                                                            ),
                                                                          ),
                                                                          style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            data
                                                                .bundle!
                                                                .validityType
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          // convertToLocalTime(
                                                          //   data.createdAt
                                                          //       .toString(),
                                                          // )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
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

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class dotline extends StatelessWidget {
  const dotline({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedLine(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      lineLength: double.infinity,
      lineThickness: 1.0,
      dashLength: 4.0,
      dashColor: AppColors.defaultColor.withOpacity(0.3),
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.white,
      dashGapRadius: 0.0,
    );
  }
}

class MyContainerList extends StatefulWidget {
  final int itemCount;

  MyContainerList({required this.itemCount});

  @override
  _MyContainerListState createState() => _MyContainerListState();
}

class _MyContainerListState extends State<MyContainerList> {
  int selectedIndex = 0;
  final box = GetStorage();
  final OrderlistController orderlistController = Get.put(
    OrderlistController(),
  );

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 40,
      width: screenWidth,
      decoration: BoxDecoration(
        // color: Colors.red,
      ),
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.itemCount,
          itemBuilder: (context, index) {
            int myindex = index + 1;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  box.write("pageNo", "${myindex}");
                  print(box.read("pageNo"));
                  orderlistController.fetchOrderlistdata();
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 5),
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: selectedIndex == index ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    myindex.toString(),
                    style: TextStyle(
                      color: selectedIndex == index
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

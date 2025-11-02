import 'package:amutelecom/controllers/dashboard_controller.dart';
import 'package:amutelecom/controllers/transaction_controller.dart';
import 'package:amutelecom/global_controller/languages_controller.dart';
import 'package:amutelecom/routes/routes.dart';
import 'package:amutelecom/screens/change_password_screen.dart';
import 'package:amutelecom/screens/commission_group_screen.dart';
import 'package:amutelecom/screens/helpscreen.dart';
import 'package:amutelecom/screens/selling_price_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyaccountScreen extends StatefulWidget {
  MyaccountScreen({super.key});

  @override
  State<MyaccountScreen> createState() => _MyaccountScreenState();
}

class _MyaccountScreenState extends State<MyaccountScreen> {
  final box = GetStorage();

  final dashboardController = Get.find<DashboardController>();
  final transactionController = Get.find<TransactionController>();

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            print(
              dashboardController
                  .alldashboardData
                  .value
                  .data!
                  .userInfo!
                  .profileImageUrl
                  .toString(),
            );
          },
          child: Text(
            languagesController.tr("ACCOUNT"),
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 100,
                width: screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xff214D3C),
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(100),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 25,
                      right: -30,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white10,
                      ),
                    ),
                    Positioned(
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey.shade300,
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
                                      width: 60,
                                      height: 60,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            // Fallback when image fails to load
                                            return Icon(
                                              Icons.person,
                                              color: Colors.grey,
                                              size: 30,
                                            );
                                          },
                                    )
                                  : Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dashboardController
                                    .alldashboardData
                                    .value
                                    .data!
                                    .userInfo!
                                    .resellerName
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                dashboardController
                                    .alldashboardData
                                    .value
                                    .data!
                                    .userInfo!
                                    .phone
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    box.read("direction") == "ltr"
                        ? Positioned(
                            bottom: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(myprofilescreen);
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.white,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Positioned(
                            bottom: 5,
                            left: 5,
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(myprofilescreen);
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.white,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 90,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(ordersscreen);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffDF514E),
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/images/order.png",
                                height: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            languagesController.tr("ORDERS"),
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(transactiontypescreen);
                        // transactionController.fetchTransactionData();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffDF514E),
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/icons/transactionsicon.png",
                                height: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            languagesController.tr("TRANSACTIONS"),
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffDF514E),
                          ),
                          child: Center(
                            child: Image.asset(
                              "assets/icons/settings.png",
                              height: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          languagesController.tr("SETTINGS"),
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => SellingPriceScreen());
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icons/set_sell_price.png",
                              height: 35,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 8),
                            Text(
                              languagesController.tr("SET_SALE_PRICE"),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => CommissionGroupScreen());
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icons/set_vendor_sell_price.png",
                              height: 35,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 8),
                            Text(
                              languagesController.tr("COMMISSION_GROUP"),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => ChangePasswordScreen());
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icons/padlock.png",
                              height: 35,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 8),
                            Text(
                              languagesController.tr("CHANGE_PASSWORD"),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => Helpscreen());
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icons/help.png",
                              height: 35,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 8),
                            Text(
                              languagesController.tr("HELP"),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 200,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Spacer(),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              box.remove("userToken");
                              setState(() {
                                Get.toNamed(signinscreen);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 5,
                                ),
                                child: Text(
                                  languagesController.tr("SIGN_OUT"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "${languagesController.tr("VERSION")} 1.0.0",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
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
    );
  }
}

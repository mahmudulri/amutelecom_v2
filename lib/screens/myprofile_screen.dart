import 'package:amutelecom/global_controller/languages_controller.dart';

import 'package:amutelecom/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:amutelecom/controllers/dashboard_controller.dart';

import 'package:amutelecom/utils/colors.dart';

import '../widgets/myprofile_box_widget.dart';

class MyprofileScreen extends StatelessWidget {
  MyprofileScreen({super.key});

  final dashboardController = Get.find<DashboardController>();

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
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),

        centerTitle: true,
        title: Text(
          languagesController.tr("PERSONAL_INFO"),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        // actions: [
        //   GestureDetector(
        //     onTap: () {
        //       Get.to(() => EditProfileScreen());
        //     },
        //     child: Icon(
        //       FontAwesomeIcons.penToSquare,
        //       color: Colors.black,
        //     ),
        //   ),
        //   SizedBox(
        //     width: 15,
        //   ),
        // ],
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              SizedBox(height: 20),
              dashboardController
                          .alldashboardData
                          .value
                          .data!
                          .userInfo!
                          .profileImageUrl !=
                      null
                  ? Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            dashboardController
                                .alldashboardData
                                .value
                                .data!
                                .userInfo!
                                .profileImageUrl
                                .toString(),
                          ),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                      ),
                    )
                  : Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 100,
                        ),
                      ),
                    ),

              SizedBox(height: 5),
              MyProfileboxwidget(
                boxname: languagesController.tr("NAME"),
                title: dashboardController
                    .alldashboardData
                    .value
                    .data!
                    .userInfo!
                    .resellerName
                    .toString(),
              ),
              SizedBox(height: 5),
              MyProfileboxwidget(
                boxname: languagesController.tr("EMAIL"),
                title: dashboardController
                    .alldashboardData
                    .value
                    .data!
                    .userInfo!
                    .email
                    .toString(),
              ),
              SizedBox(height: 5),
              MyProfileboxwidget(
                boxname: languagesController.tr("PHONENUMBER"),
                title: dashboardController
                    .alldashboardData
                    .value
                    .data!
                    .userInfo!
                    .phone
                    .toString(),
              ),
              SizedBox(height: 5),
              MyProfileboxwidget(
                boxname: languagesController.tr("BALANCE"),
                title: dashboardController
                    .alldashboardData
                    .value
                    .data!
                    .userInfo!
                    .balance
                    .toString(),
              ),
              SizedBox(height: 5),
              MyProfileboxwidget(
                boxname: languagesController.tr("LOAN_BALANCE"),
                title: dashboardController
                    .alldashboardData
                    .value
                    .data!
                    .userInfo!
                    .loanBalance
                    .toString(),
              ),
              SizedBox(height: 5),
              MyProfileboxwidget(
                boxname: languagesController.tr("TOTAL_SOLD_AMOUNT"),
                title: dashboardController
                    .alldashboardData
                    .value
                    .data!
                    .totalSoldAmount
                    .toString(),
              ),
              SizedBox(height: 5),
              MyProfileboxwidget(
                boxname: languagesController.tr("TOTAL_REVENUE"),
                title: dashboardController
                    .alldashboardData
                    .value
                    .data!
                    .totalRevenue
                    .toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

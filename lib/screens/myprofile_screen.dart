import 'package:amutelecom/global_controller/languages_controller.dart';
import 'package:amutelecom/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amutelecom/controllers/dashboard_controller.dart';
import 'package:amutelecom/utils/colors.dart';

class MyprofileScreen extends StatelessWidget {
  MyprofileScreen({super.key});

  final dashboardController = Get.find<DashboardController>();
  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          languagesController.tr("PERSONAL_INFO"),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.defaultColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.defaultColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Profile Image
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child:
                          dashboardController
                                  .alldashboardData
                                  .value
                                  .data!
                                  .userInfo!
                                  .profileImageUrl !=
                              null
                          ? Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
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
                              ),
                            )
                          : Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.3),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            dashboardController
                                .alldashboardData
                                .value
                                .data!
                                .userInfo!
                                .phone
                                .toString(),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),
              // Contact Information Section
              _buildSectionTitle("Contact Information", Icons.contact_mail),
              SizedBox(height: 12),
              _buildInfoCard(
                icon: Icons.email_outlined,
                label: languagesController.tr("EMAIL"),
                value: dashboardController
                    .alldashboardData
                    .value
                    .data!
                    .userInfo!
                    .email
                    .toString(),
                iconColor: Colors.blue,
              ),
              SizedBox(height: 10),
              _buildInfoCard(
                icon: Icons.phone_outlined,
                label: languagesController.tr("PHONENUMBER"),
                value: dashboardController
                    .alldashboardData
                    .value
                    .data!
                    .userInfo!
                    .phone
                    .toString(),
                iconColor: Colors.green,
              ),

              SizedBox(height: 10),

              // Financial Information Section
              _buildSectionTitle(
                "Financial Overview",
                Icons.account_balance_wallet,
              ),
              SizedBox(height: 12),

              // Balance Cards Grid
              Row(
                children: [
                  Expanded(
                    child: _buildBalanceCard(
                      label: languagesController.tr("BALANCE"),
                      value: dashboardController
                          .alldashboardData
                          .value
                          .data!
                          .userInfo!
                          .balance
                          .toString(),
                      icon: Icons.account_balance_wallet_outlined,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildBalanceCard(
                      label: languagesController.tr("LOAN_BALANCE"),
                      value: dashboardController
                          .alldashboardData
                          .value
                          .data!
                          .userInfo!
                          .loanBalance
                          .toString(),
                      icon: Icons.money_off_outlined,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              _buildInfoCard(
                icon: Icons.monetization_on_outlined,
                label: languagesController.tr("TOTAL_SOLD_AMOUNT"),
                value: dashboardController
                    .alldashboardData
                    .value
                    .data!
                    .totalSoldAmount
                    .toString(),
                iconColor: Colors.purple,
              ),

              SizedBox(height: 12),

              _buildInfoCard(
                icon: Icons.trending_up,
                label: languagesController.tr("TOTAL_REVENUE"),
                value: dashboardController
                    .alldashboardData
                    .value
                    .data!
                    .totalRevenue
                    .toString(),
                iconColor: Colors.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.defaultColor),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

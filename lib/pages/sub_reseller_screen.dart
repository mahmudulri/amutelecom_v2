import 'package:amutelecom/controllers/dashboard_controller.dart';
import 'package:amutelecom/global_controller/languages_controller.dart';
import 'package:amutelecom/helpers/language_helper.dart';
import 'package:amutelecom/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:amutelecom/controllers/change_status_controller.dart';
import 'package:amutelecom/controllers/delete_sub_reseller.dart';
import 'package:amutelecom/controllers/language_controller.dart';
import 'package:amutelecom/controllers/sub_reseller_controller.dart';
import 'package:amutelecom/controllers/subreseller_details_controller.dart';
import 'package:amutelecom/screens/add_sub_reseller_screen.dart';
import 'package:amutelecom/services/subreseller_details_service.dart';
import 'package:amutelecom/utils/colors.dart';
import 'package:amutelecom/widgets/auth_textfield.dart';
import 'package:amutelecom/widgets/default_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controllers/commission_group_controller.dart';
import '../controllers/set_commission_group_controller.dart';
import '../screens/set_subreseller_pin.dart';
import '../widgets/myprofile_box_widget.dart';
import '../screens/change_balance_screen.dart';
import '../screens/change_sub_pass_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/update_sub_reseller_screen.dart';

class SubResellerScreen extends StatefulWidget {
  SubResellerScreen({super.key});

  @override
  State<SubResellerScreen> createState() => _SubResellerScreenState();
}

class _SubResellerScreenState extends State<SubResellerScreen> {
  final box = GetStorage();

  final languageController = Get.find<LanguagesController>();
  final subresellerController = Get.find<SubresellerController>();

  TextEditingController searchController = TextEditingController();
  LanguagesController languagesController = Get.put(LanguagesController());

  final dashboardController = Get.find<DashboardController>();

  final DeleteSubResellerController deleteSubResellerController = Get.put(
    DeleteSubResellerController(),
  );

  final ChangeStatusController changeStatusController = Get.put(
    ChangeStatusController(),
  );

  final SubresellerDetailsController detailsController = Get.put(
    SubresellerDetailsController(),
  );

  CommissionGroupController commissionlistController = Get.put(
    CommissionGroupController(),
  );

  SetCommissionGroupController controller = Get.put(
    SetCommissionGroupController(),
  );

  final ScrollController scrollController = ScrollController();

  Future<void> refresh() async {
    final int totalPages =
        subresellerController
            .allsubresellerData
            .value
            .payload
            ?.pagination!
            .lastPage ??
        0;
    final int currentPage = subresellerController.initialpage;

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
      subresellerController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (subresellerController.initialpage <= totalPages) {
        print("Load More...................");
        subresellerController.fetchSubReseller();
      } else {
        subresellerController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  String search = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    box.write("search_target", "");
    subresellerController.initialpage = 1;
    subresellerController.finalList.clear();
    subresellerController.fetchSubReseller();
    scrollController.addListener(refresh);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            // dashboardController.isLoading.value = false;
            print(box.read("search_target"));
          },
          child: Text(
            languageController.tr("SUB_RESELLER"),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: dashboardController.myerror.value != "Deactivated"
          ? Container(
              height: screenHeight,
              width: screenWidth,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Row(
                        children: [
                          // Search Field
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.3),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      onChanged: (String? value) {
                                        box.write(
                                          "search_target",
                                          value.toString(),
                                        );

                                        if (value == null || value.isEmpty) {
                                          subresellerController.initialpage = 1;
                                          subresellerController.finalList
                                              .clear();
                                          subresellerController
                                              .fetchSubReseller();
                                        }
                                      },
                                      controller: searchController,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF212529),
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: languageController.tr(
                                          "SEARCH",
                                        ),
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      subresellerController.initialpage = 1;
                                      subresellerController.finalList.clear();
                                      subresellerController.fetchSubReseller();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(right: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.defaultColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.search,
                                        color: AppColors.defaultColor,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          // Add New Button
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(addsubresellerscreen);
                            },
                            child: Container(
                              height: 55,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.defaultColor,
                                    AppColors.defaultColor.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.defaultColor.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    languageController.tr("ADD_NEW"),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Obx(
                      () => subresellerController.isLoading.value == true
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
                    SizedBox(height: 10),
                    Obx(
                      () => subresellerController.isLoading.value == false
                          ? Container(
                              child:
                                  subresellerController
                                      .allsubresellerData
                                      .value
                                      .data!
                                      .resellers
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
                                            "No Data found",
                                            style: TextStyle(),
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
                            subresellerController.isLoading.value == false &&
                                subresellerController.finalList.isNotEmpty
                            ? RefreshIndicator(
                                onRefresh: refresh,
                                child: ListView.separated(
                                  shrinkWrap: false,
                                  controller: scrollController,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 8),
                                  itemCount:
                                      subresellerController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        subresellerController.finalList[index];

                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.08,
                                            ),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          // Header Section
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                255,
                                                202,
                                                236,
                                                202,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                topRight: Radius.circular(12),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                // Profile Image
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: AppColors
                                                          .defaultColor
                                                          .withOpacity(0.2),
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child:
                                                      data.profileImageUrl
                                                              .toString() !=
                                                          "null"
                                                      ? CircleAvatar(
                                                          radius: 24,
                                                          backgroundImage:
                                                              NetworkImage(
                                                                data.profileImageUrl
                                                                    .toString(),
                                                              ),
                                                        )
                                                      : CircleAvatar(
                                                          radius: 24,
                                                          backgroundColor:
                                                              AppColors
                                                                  .defaultColor
                                                                  .withOpacity(
                                                                    0.1,
                                                                  ),
                                                          child: Icon(
                                                            Icons.person,
                                                            color: AppColors
                                                                .defaultColor,
                                                            size: 24,
                                                          ),
                                                        ),
                                                ),
                                                SizedBox(width: 10),
                                                // Name and Phone
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data.resellerName
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Color(
                                                            0xFF212529,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 2),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.phone,
                                                            size: 12,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                          SizedBox(width: 4),
                                                          Text(
                                                            data.phone
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Action Button
                                                GestureDetector(
                                                  onTap: () {
                                                    box.write(
                                                      "subresellerID",
                                                      data.id,
                                                    );
                                                    detailsController
                                                        .fetchSubResellerDetails(
                                                          data.id.toString(),
                                                        );
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  16,
                                                                ),
                                                          ),
                                                          child: Container(
                                                            constraints:
                                                                BoxConstraints(
                                                                  maxHeight:
                                                                      500,
                                                                ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                // Dialog Header
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets.all(
                                                                        16,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    color: AppColors
                                                                        .defaultColor,
                                                                    borderRadius: BorderRadius.only(
                                                                      topLeft:
                                                                          Radius.circular(
                                                                            16,
                                                                          ),
                                                                      topRight:
                                                                          Radius.circular(
                                                                            16,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        languageController.tr(
                                                                          "ACTION",
                                                                        ),
                                                                        style: TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      Spacer(),
                                                                      GestureDetector(
                                                                        onTap: () =>
                                                                            Navigator.pop(
                                                                              context,
                                                                            ),
                                                                        child: Icon(
                                                                          Icons
                                                                              .close,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                // Dialog Content
                                                                Flexible(
                                                                  child: SingleChildScrollView(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                          16,
                                                                        ),
                                                                    child: Column(
                                                                      children: [
                                                                        _buildActionItem(
                                                                          icon:
                                                                              Icons.power_settings_new,
                                                                          title:
                                                                              data.status
                                                                                      .toString() ==
                                                                                  "0"
                                                                              ? languageController.tr(
                                                                                  "ACTIVE",
                                                                                )
                                                                              : languageController.tr(
                                                                                  "DEACTIVE",
                                                                                ),
                                                                          trailing: CircleAvatar(
                                                                            radius:
                                                                                8,
                                                                            backgroundColor:
                                                                                data.status.toString() ==
                                                                                    "0"
                                                                                ? Colors.green
                                                                                : Colors.grey,
                                                                          ),
                                                                          onTap: () {
                                                                            changeStatusController.channgestatus(
                                                                              data.id.toString(),
                                                                            );
                                                                            Navigator.pop(
                                                                              context,
                                                                            );
                                                                          },
                                                                        ),
                                                                        _buildActionItem(
                                                                          icon:
                                                                              Icons.delete_outline,
                                                                          title: languageController.tr(
                                                                            "DELETE",
                                                                          ),
                                                                          iconColor:
                                                                              Colors.red,
                                                                          onTap: () {
                                                                            deleteSubResellerController.deletesub(
                                                                              data.id.toString(),
                                                                            );
                                                                            Navigator.pop(
                                                                              context,
                                                                            );
                                                                          },
                                                                        ),
                                                                        _buildActionItem(
                                                                          iconAsset:
                                                                              "assets/icons/padlock.png",
                                                                          title: languagesController.tr(
                                                                            "SET_PIN",
                                                                          ),
                                                                          onTap: () {
                                                                            Get.to(
                                                                              () => SetSubresellerPin(
                                                                                subID: data.id.toString(),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                        _buildActionItem(
                                                                          iconAsset:
                                                                              "assets/images/discount.png",
                                                                          title: languagesController.tr(
                                                                            "SET_COMMISSION_GROUP",
                                                                          ),
                                                                          onTap: () async {
                                                                            showModalBottomSheet(
                                                                              context: context,
                                                                              backgroundColor: Colors.white,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.vertical(
                                                                                  top: Radius.circular(
                                                                                    20,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              builder:
                                                                                  (
                                                                                    context,
                                                                                  ) {
                                                                                    return Obx(
                                                                                      () {
                                                                                        if (commissionlistController.isLoading.value) {
                                                                                          return Center(
                                                                                            child: CircularProgressIndicator(),
                                                                                          );
                                                                                        }

                                                                                        final groups =
                                                                                            commissionlistController.allgrouplist.value.data?.groups ??
                                                                                            [];

                                                                                        return ListView.builder(
                                                                                          itemCount: groups.length,
                                                                                          itemBuilder:
                                                                                              (
                                                                                                context,
                                                                                                index,
                                                                                              ) {
                                                                                                final group = groups[index];
                                                                                                return ListTile(
                                                                                                  title: Text(
                                                                                                    group.groupName ??
                                                                                                        '',
                                                                                                  ),
                                                                                                  subtitle: Text(
                                                                                                    "${group.amount} ${group.commissionType == 'percentage' ? '%' : ''}",
                                                                                                  ),
                                                                                                  trailing:
                                                                                                      data.id.toString() ==
                                                                                                          group.id.toString()
                                                                                                      ? Icon(
                                                                                                          Icons.check_circle,
                                                                                                          color: Colors.green,
                                                                                                        )
                                                                                                      : null,
                                                                                                  onTap: () async {
                                                                                                    Navigator.pop(
                                                                                                      context,
                                                                                                    );
                                                                                                    await controller.setgroup(
                                                                                                      data.id.toString(),
                                                                                                      group.id.toString(),
                                                                                                    );
                                                                                                  },
                                                                                                );
                                                                                              },
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  },
                                                                            );
                                                                          },
                                                                        ),
                                                                        _buildActionItem(
                                                                          icon:
                                                                              Icons.lock_outline,
                                                                          title: languageController.tr(
                                                                            "SET_PASSWORD",
                                                                          ),
                                                                          onTap: () {
                                                                            Get.to(
                                                                              () => ChangeSubPasswordScreen(
                                                                                subID: data.id.toString(),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                        _buildActionItem(
                                                                          icon:
                                                                              Icons.account_balance_wallet_outlined,
                                                                          title: languageController.tr(
                                                                            "CHANGE_BALANCE",
                                                                          ),
                                                                          onTap: () {
                                                                            Get.to(
                                                                              () => ChangeBalanceScreen(
                                                                                subID: data.id.toString(),
                                                                              ),
                                                                            );
                                                                          },
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
                                                    );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 6,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .defaultColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.more_horiz,
                                                          color: Colors.white,
                                                          size: 16,
                                                        ),
                                                        SizedBox(width: 2),
                                                        Text(
                                                          languageController.tr(
                                                            "ACTION",
                                                          ),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Stats Section
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    children: [
                                                      _buildCompactStatCard(
                                                        value: "0",
                                                        label: languageController
                                                            .tr("TODAY_ORDERS"),
                                                        icon: Icons
                                                            .shopping_bag_outlined,
                                                        color: Color(
                                                          0xFF4CAF50,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      _buildCompactStatCard(
                                                        value: "0",
                                                        label: languageController
                                                            .tr("TOTAL_ORDERS"),
                                                        icon: Icons
                                                            .receipt_long_outlined,
                                                        color: Color(
                                                          0xFF2196F3,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  flex: 3,
                                                  child: _buildCompactStatCard(
                                                    value: data.balance
                                                        .toString(),
                                                    label: languageController
                                                        .tr("CURRENT_BALANCE"),
                                                    icon: Icons
                                                        .account_balance_wallet_outlined,
                                                    color: Color(0xFFFF9800),
                                                    highlight: true,
                                                    isLarge: true,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    children: [
                                                      _buildCompactStatCard(
                                                        value: "0",
                                                        label:
                                                            languageController
                                                                .tr(
                                                                  "TOTAL_SALE",
                                                                ),
                                                        icon: Icons.trending_up,
                                                        color: Color(
                                                          0xFF9C27B0,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      _buildCompactStatCard(
                                                        value: "0",
                                                        label:
                                                            languageController
                                                                .tr(
                                                                  "TODAY_SALE",
                                                                ),
                                                        icon: Icons
                                                            .monetization_on_outlined,
                                                        color: Color(
                                                          0xFFE91E63,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : subresellerController.finalList.isEmpty
                            ? SizedBox()
                            : RefreshIndicator(
                                onRefresh: refresh,
                                child: ListView.separated(
                                  shrinkWrap: false,
                                  controller: scrollController,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(horizontal: 0),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 8),
                                  itemCount:
                                      subresellerController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        subresellerController.finalList[index];

                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.08,
                                            ),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          // Header Section
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                255,
                                                202,
                                                236,
                                                202,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                topRight: Radius.circular(12),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                // Profile Image
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: AppColors
                                                          .defaultColor
                                                          .withOpacity(0.2),
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child:
                                                      data.profileImageUrl
                                                              .toString() !=
                                                          "null"
                                                      ? CircleAvatar(
                                                          radius: 24,
                                                          backgroundImage:
                                                              NetworkImage(
                                                                data.profileImageUrl
                                                                    .toString(),
                                                              ),
                                                        )
                                                      : CircleAvatar(
                                                          radius: 24,
                                                          backgroundColor:
                                                              AppColors
                                                                  .defaultColor
                                                                  .withOpacity(
                                                                    0.1,
                                                                  ),
                                                          child: Icon(
                                                            Icons.person,
                                                            color: AppColors
                                                                .defaultColor,
                                                            size: 24,
                                                          ),
                                                        ),
                                                ),
                                                SizedBox(width: 10),
                                                // Name and Phone
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data.resellerName
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Color(
                                                            0xFF212529,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 2),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.phone,
                                                            size: 12,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                          SizedBox(width: 4),
                                                          Text(
                                                            data.phone
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Action Button
                                                GestureDetector(
                                                  onTap: () {
                                                    box.write(
                                                      "subresellerID",
                                                      data.id,
                                                    );
                                                    detailsController
                                                        .fetchSubResellerDetails(
                                                          data.id.toString(),
                                                        );
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  16,
                                                                ),
                                                          ),
                                                          child: Container(
                                                            constraints:
                                                                BoxConstraints(
                                                                  maxHeight:
                                                                      500,
                                                                ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                // Dialog Header
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets.all(
                                                                        16,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    color: AppColors
                                                                        .defaultColor,
                                                                    borderRadius: BorderRadius.only(
                                                                      topLeft:
                                                                          Radius.circular(
                                                                            16,
                                                                          ),
                                                                      topRight:
                                                                          Radius.circular(
                                                                            16,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        languageController.tr(
                                                                          "ACTION",
                                                                        ),
                                                                        style: TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      Spacer(),
                                                                      GestureDetector(
                                                                        onTap: () =>
                                                                            Navigator.pop(
                                                                              context,
                                                                            ),
                                                                        child: Icon(
                                                                          Icons
                                                                              .close,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                // Dialog Content
                                                                Flexible(
                                                                  child: SingleChildScrollView(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                          16,
                                                                        ),
                                                                    child: Column(
                                                                      children: [
                                                                        _buildActionItem(
                                                                          icon:
                                                                              Icons.power_settings_new,
                                                                          title:
                                                                              data.status
                                                                                      .toString() ==
                                                                                  "0"
                                                                              ? languageController.tr(
                                                                                  "ACTIVE",
                                                                                )
                                                                              : languageController.tr(
                                                                                  "DEACTIVE",
                                                                                ),
                                                                          trailing: CircleAvatar(
                                                                            radius:
                                                                                8,
                                                                            backgroundColor:
                                                                                data.status.toString() ==
                                                                                    "0"
                                                                                ? Colors.green
                                                                                : Colors.grey,
                                                                          ),
                                                                          onTap: () {
                                                                            changeStatusController.channgestatus(
                                                                              data.id.toString(),
                                                                            );
                                                                            Navigator.pop(
                                                                              context,
                                                                            );
                                                                          },
                                                                        ),
                                                                        _buildActionItem(
                                                                          icon:
                                                                              Icons.delete_outline,
                                                                          title: languageController.tr(
                                                                            "DELETE",
                                                                          ),
                                                                          iconColor:
                                                                              Colors.red,
                                                                          onTap: () {
                                                                            deleteSubResellerController.deletesub(
                                                                              data.id.toString(),
                                                                            );
                                                                            Navigator.pop(
                                                                              context,
                                                                            );
                                                                          },
                                                                        ),
                                                                        _buildActionItem(
                                                                          iconAsset:
                                                                              "assets/icons/padlock.png",
                                                                          title: languagesController.tr(
                                                                            "SET_PIN",
                                                                          ),
                                                                          onTap: () {
                                                                            Get.to(
                                                                              () => SetSubresellerPin(
                                                                                subID: data.id.toString(),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                        _buildActionItem(
                                                                          iconAsset:
                                                                              "assets/images/discount.png",
                                                                          title: languagesController.tr(
                                                                            "SET_COMMISSION_GROUP",
                                                                          ),
                                                                          onTap: () async {
                                                                            showModalBottomSheet(
                                                                              context: context,
                                                                              backgroundColor: Colors.white,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.vertical(
                                                                                  top: Radius.circular(
                                                                                    20,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              builder:
                                                                                  (
                                                                                    context,
                                                                                  ) {
                                                                                    return Obx(
                                                                                      () {
                                                                                        if (commissionlistController.isLoading.value) {
                                                                                          return Center(
                                                                                            child: CircularProgressIndicator(),
                                                                                          );
                                                                                        }

                                                                                        final groups =
                                                                                            commissionlistController.allgrouplist.value.data?.groups ??
                                                                                            [];

                                                                                        return ListView.builder(
                                                                                          itemCount: groups.length,
                                                                                          itemBuilder:
                                                                                              (
                                                                                                context,
                                                                                                index,
                                                                                              ) {
                                                                                                final group = groups[index];
                                                                                                return ListTile(
                                                                                                  title: Text(
                                                                                                    group.groupName ??
                                                                                                        '',
                                                                                                  ),
                                                                                                  subtitle: Text(
                                                                                                    "${group.amount} ${group.commissionType == 'percentage' ? '%' : ''}",
                                                                                                  ),
                                                                                                  trailing:
                                                                                                      data.id.toString() ==
                                                                                                          group.id.toString()
                                                                                                      ? Icon(
                                                                                                          Icons.check_circle,
                                                                                                          color: Colors.green,
                                                                                                        )
                                                                                                      : null,
                                                                                                  onTap: () async {
                                                                                                    Navigator.pop(
                                                                                                      context,
                                                                                                    );
                                                                                                    await controller.setgroup(
                                                                                                      data.id.toString(),
                                                                                                      group.id.toString(),
                                                                                                    );
                                                                                                  },
                                                                                                );
                                                                                              },
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  },
                                                                            );
                                                                          },
                                                                        ),
                                                                        _buildActionItem(
                                                                          icon:
                                                                              Icons.lock_outline,
                                                                          title: languageController.tr(
                                                                            "SET_PASSWORD",
                                                                          ),
                                                                          onTap: () {
                                                                            Get.to(
                                                                              () => ChangeSubPasswordScreen(
                                                                                subID: data.id.toString(),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                        _buildActionItem(
                                                                          icon:
                                                                              Icons.account_balance_wallet_outlined,
                                                                          title: languageController.tr(
                                                                            "CHANGE_BALANCE",
                                                                          ),
                                                                          onTap: () {
                                                                            Get.to(
                                                                              () => ChangeBalanceScreen(
                                                                                subID: data.id.toString(),
                                                                              ),
                                                                            );
                                                                          },
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
                                                    );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 6,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .defaultColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.more_horiz,
                                                          color: Colors.white,
                                                          size: 16,
                                                        ),
                                                        SizedBox(width: 2),
                                                        Text(
                                                          languageController.tr(
                                                            "ACTION",
                                                          ),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Stats Section
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    children: [
                                                      _buildCompactStatCard(
                                                        value: "0",
                                                        label: languageController
                                                            .tr("TODAY_ORDERS"),
                                                        icon: Icons
                                                            .shopping_bag_outlined,
                                                        color: Color(
                                                          0xFF4CAF50,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      _buildCompactStatCard(
                                                        value: "0",
                                                        label: languageController
                                                            .tr("TOTAL_ORDERS"),
                                                        icon: Icons
                                                            .receipt_long_outlined,
                                                        color: Color(
                                                          0xFF2196F3,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  flex: 3,
                                                  child: _buildCompactStatCard(
                                                    value: data.balance
                                                        .toString(),
                                                    label: languageController
                                                        .tr("CURRENT_BALANCE"),
                                                    icon: Icons
                                                        .account_balance_wallet_outlined,
                                                    color: Color(0xFFFF9800),
                                                    highlight: true,
                                                    isLarge: true,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    children: [
                                                      _buildCompactStatCard(
                                                        value: "0",
                                                        label:
                                                            languageController
                                                                .tr(
                                                                  "TOTAL_SALE",
                                                                ),
                                                        icon: Icons.trending_up,
                                                        color: Color(
                                                          0xFF9C27B0,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      _buildCompactStatCard(
                                                        value: "0",
                                                        label:
                                                            languageController
                                                                .tr(
                                                                  "TODAY_SALE",
                                                                ),
                                                        icon: Icons
                                                            .monetization_on_outlined,
                                                        color: Color(
                                                          0xFFE91E63,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dashboardController.myerror.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      dashboardController.message.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
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
                  ],
                ),
              ),
            ),
    );
  }
}

// Helper method for compact stat cards
Widget _buildCompactStatCard({
  required String value,
  required String label,
  required IconData icon,
  required Color color,
  bool highlight = false,
  bool isLarge = false,
}) {
  return Container(
    height: isLarge ? null : 80,
    width: 100,
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: highlight ? color.withOpacity(0.1) : Colors.white,
      border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: isLarge ? 28 : 20),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isLarge ? 18 : 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212529),
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(fontSize: 9, color: Colors.grey[600], height: 1.1),
        ),
      ],
    ),
  );
}

// Helper method for action items
Widget _buildActionItem({
  IconData? icon,
  String? iconAsset,
  required String title,
  Color? iconColor,
  Widget? trailing,
  required VoidCallback onTap,
}) {
  return Column(
    children: [
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (iconColor ?? Colors.grey[700])!.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: icon != null
                      ? Icon(
                          icon,
                          color: iconColor ?? Colors.grey[700],
                          size: 20,
                        )
                      : Image.asset(iconAsset!, height: 20, width: 20),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF212529),
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
      Divider(height: 1, thickness: 1),
    ],
  );
}

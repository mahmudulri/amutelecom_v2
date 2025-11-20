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
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: screenWidth,

                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        onChanged: (String? value) {
                                          box.write(
                                            "search_target",
                                            value.toString(),
                                          );

                                          if (value == null || value.isEmpty) {
                                            subresellerController.initialpage =
                                                1;
                                            subresellerController.finalList
                                                .clear();
                                            subresellerController
                                                .fetchSubReseller();
                                          }
                                        },
                                        controller: searchController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: languageController.tr(
                                            "SEARCH",
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          subresellerController.initialpage = 1;
                                          subresellerController.finalList
                                              .clear();
                                          subresellerController
                                              .fetchSubReseller();
                                        },
                                        child: Icon(
                                          Icons.search,
                                          color: Colors.grey,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(addsubresellerscreen);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.defaultColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Center(
                                    child: Text(
                                      languageController.tr("ADD_NEW"),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
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
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 8);
                                  },
                                  itemCount:
                                      subresellerController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        subresellerController.finalList[index];

                                    return Container(
                                      height: 250,
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
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: screenWidth,
                                            // color: Colors.cyan,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                              child: Row(
                                                children: [
                                                  data.profileImageUrl
                                                              .toString() !=
                                                          "null"
                                                      ? CircleAvatar(
                                                          radius: 22,
                                                          backgroundImage:
                                                              NetworkImage(
                                                                data.profileImageUrl
                                                                    .toString(),
                                                              ),
                                                        )
                                                      : CircleAvatar(
                                                          radius: 22,
                                                          backgroundColor:
                                                              Colors.grey,
                                                        ),
                                                  SizedBox(width: 10),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data.resellerName
                                                            .toString(),
                                                      ),
                                                      Text(
                                                        data.phone.toString(),
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
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
                                                          return AlertDialog(
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                  0.0,
                                                                ),
                                                            content: Container(
                                                              height: 300,
                                                              width:
                                                                  screenWidth -
                                                                  100,
                                                              decoration:
                                                                  BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.all(
                                                                      12.0,
                                                                    ),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        changeStatusController.channgestatus(
                                                                          data.id
                                                                              .toString(),
                                                                        );
                                                                        Navigator.pop(
                                                                          context,
                                                                        );
                                                                      },
                                                                      child: Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.ac_unit,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Text(
                                                                            data.status
                                                                                        .toString() ==
                                                                                    "0"
                                                                                ? languageController.tr(
                                                                                    "ACTIVE",
                                                                                  )
                                                                                : languageController.tr(
                                                                                    "DEACTIVE",
                                                                                  ),
                                                                          ),
                                                                          Spacer(),
                                                                          CircleAvatar(
                                                                            radius:
                                                                                8,
                                                                            backgroundColor:
                                                                                data.status.toString() ==
                                                                                    "0"
                                                                                ? Colors.grey
                                                                                : Colors.green,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      thickness:
                                                                          1,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        deleteSubResellerController.deletesub(
                                                                          data.id
                                                                              .toString(),
                                                                        );
                                                                        Navigator.pop(
                                                                          context,
                                                                        );
                                                                      },
                                                                      child: Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.delete,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Text(
                                                                            languageController.tr(
                                                                              "DELETE",
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      thickness:
                                                                          1,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        Get.to(
                                                                          () => SetSubresellerPin(
                                                                            subID:
                                                                                data.id.toString(),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: Row(
                                                                        children: [
                                                                          Image.asset(
                                                                            "assets/icons/padlock.png",
                                                                            height:
                                                                                25,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Text(
                                                                            languagesController.tr(
                                                                              "SET_PIN",
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      thickness:
                                                                          1,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () async {
                                                                        showModalBottomSheet(
                                                                          context:
                                                                              context,
                                                                          backgroundColor:
                                                                              Colors.white,
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
                                                                                                      Icons.check,
                                                                                                      color: Colors.green,
                                                                                                    )
                                                                                                  : null,
                                                                                              onTap: () async {
                                                                                                Navigator.pop(
                                                                                                  context,
                                                                                                ); // বন্ধ করে দেই BottomSheet
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
                                                                      child: Row(
                                                                        children: [
                                                                          Image.asset(
                                                                            "assets/images/discount.png",
                                                                            height:
                                                                                25,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Text(
                                                                            languagesController.tr(
                                                                              "SET_COMMISSION_GROUP",
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      thickness:
                                                                          1,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        Get.to(
                                                                          () => ChangeSubPasswordScreen(
                                                                            subID:
                                                                                data.id.toString(),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.password,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Text(
                                                                            languageController.tr(
                                                                              "SET_PASSWORD",
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      thickness:
                                                                          1,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        Get.to(
                                                                          () => ChangeBalanceScreen(
                                                                            subID:
                                                                                data.id.toString(),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.edit,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Text(
                                                                            languageController.tr(
                                                                              "CHANGE_BALANCE",
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                        // color: Color(0xff46558A),
                                                        color: AppColors
                                                            .defaultColor,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              5,
                                                            ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 15,
                                                            ),
                                                        child: Center(
                                                          child: Text(
                                                            languageController
                                                                .tr("ACTION"),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: Container(
                                              height: 1,
                                              width: screenWidth,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                5.0,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      7,
                                                                    ),
                                                              ),
                                                              child: Center(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "0",
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      languageController.tr(
                                                                        "TODAY_ORDERS",
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      7,
                                                                    ),
                                                              ),
                                                              child: Center(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "0",
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      languageController.tr(
                                                                        "TOTAL_ORDERS",
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
                                                  ),
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: 1,
                                                          color: Colors.black,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              7,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              data.balance
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            Text(
                                                              languageController.tr(
                                                                "CURRENT_BALANCE",
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
                                                    child: Container(
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      7,
                                                                    ),
                                                              ),
                                                              child: Center(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "0",
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      languageController.tr(
                                                                        "TOTAL_SALE",
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      7,
                                                                    ),
                                                              ),
                                                              child: Center(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "0",
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      languageController.tr(
                                                                        "TODAY_SALE",
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                                ],
                                              ),
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
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 8);
                                  },
                                  itemCount:
                                      subresellerController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        subresellerController.finalList[index];

                                    return Container(
                                      height: 250,
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
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: screenWidth,
                                            // color: Colors.cyan,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                              child: Row(
                                                children: [
                                                  data.profileImageUrl
                                                              .toString() !=
                                                          "null"
                                                      ? CircleAvatar(
                                                          radius: 22,
                                                          backgroundImage:
                                                              NetworkImage(
                                                                data.profileImageUrl
                                                                    .toString(),
                                                              ),
                                                        )
                                                      : CircleAvatar(
                                                          radius: 22,
                                                          backgroundColor:
                                                              Colors.grey,
                                                        ),
                                                  SizedBox(width: 10),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data.resellerName
                                                            .toString(),
                                                      ),
                                                      Text(
                                                        data.phone.toString(),
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
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
                                                          return AlertDialog(
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                  0.0,
                                                                ),
                                                            content: Container(
                                                              height: 300,
                                                              width:
                                                                  screenWidth -
                                                                  100,
                                                              decoration:
                                                                  BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.all(
                                                                      12.0,
                                                                    ),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        changeStatusController.channgestatus(
                                                                          data.id
                                                                              .toString(),
                                                                        );
                                                                        Navigator.pop(
                                                                          context,
                                                                        );
                                                                      },
                                                                      child: Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.ac_unit,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Text(
                                                                            data.status
                                                                                        .toString() ==
                                                                                    "0"
                                                                                ? languageController.tr(
                                                                                    "ACTIVE",
                                                                                  )
                                                                                : languageController.tr(
                                                                                    "DEACTIVE",
                                                                                  ),
                                                                          ),
                                                                          Spacer(),
                                                                          CircleAvatar(
                                                                            radius:
                                                                                8,
                                                                            backgroundColor:
                                                                                data.status.toString() ==
                                                                                    "0"
                                                                                ? Colors.grey
                                                                                : Colors.green,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      thickness:
                                                                          1,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        deleteSubResellerController.deletesub(
                                                                          data.id
                                                                              .toString(),
                                                                        );
                                                                        Navigator.pop(
                                                                          context,
                                                                        );
                                                                      },
                                                                      child: Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.delete,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Text(
                                                                            languageController.tr(
                                                                              "DELETE",
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      thickness:
                                                                          1,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        Get.to(
                                                                          () => SetSubresellerPin(
                                                                            subID:
                                                                                data.id.toString(),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: Row(
                                                                        children: [
                                                                          Image.asset(
                                                                            "assets/icons/padlock.png",
                                                                            height:
                                                                                25,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Text(
                                                                            languagesController.tr(
                                                                              "SET_PIN",
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      thickness:
                                                                          1,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () async {
                                                                        showModalBottomSheet(
                                                                          context:
                                                                              context,
                                                                          backgroundColor:
                                                                              Colors.white,
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
                                                                                                      Icons.check,
                                                                                                      color: Colors.green,
                                                                                                    )
                                                                                                  : null,
                                                                                              onTap: () async {
                                                                                                Navigator.pop(
                                                                                                  context,
                                                                                                ); // বন্ধ করে দেই BottomSheet
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
                                                                      child: Row(
                                                                        children: [
                                                                          Image.asset(
                                                                            "assets/images/discount.png",
                                                                            height:
                                                                                25,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Text(
                                                                            languagesController.tr(
                                                                              "SET_COMMISSION_GROUP",
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      thickness:
                                                                          1,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        Get.to(
                                                                          () => ChangeSubPasswordScreen(
                                                                            subID:
                                                                                data.id.toString(),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.password,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Text(
                                                                            languageController.tr(
                                                                              "SET_PASSWORD",
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      thickness:
                                                                          1,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        Get.to(
                                                                          () => ChangeBalanceScreen(
                                                                            subID:
                                                                                data.id.toString(),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.edit,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Text(
                                                                            languageController.tr(
                                                                              "CHANGE_BALANCE",
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                        // color: Color(0xff46558A),
                                                        color: AppColors
                                                            .defaultColor,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              5,
                                                            ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 15,
                                                            ),
                                                        child: Center(
                                                          child: Text(
                                                            languageController
                                                                .tr("ACTION"),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: Container(
                                              height: 1,
                                              width: screenWidth,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                5.0,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      7,
                                                                    ),
                                                              ),
                                                              child: Center(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "0",
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      languageController.tr(
                                                                        "TODAY_ORDERS",
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      7,
                                                                    ),
                                                              ),
                                                              child: Center(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "0",
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      languageController.tr(
                                                                        "TOTAL_ORDERS",
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
                                                  ),
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: 1,
                                                          color: Colors.black,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              7,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              data.balance
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            Text(
                                                              languageController.tr(
                                                                "CURRENT_BALANCE",
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
                                                    child: Container(
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      7,
                                                                    ),
                                                              ),
                                                              child: Center(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "0",
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      languageController.tr(
                                                                        "TOTAL_SALE",
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      7,
                                                                    ),
                                                              ),
                                                              child: Center(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "0",
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      languageController.tr(
                                                                        "TODAY_SALE",
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                                ],
                                              ),
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

import 'package:amutelecom/global_controller/languages_controller.dart';
import 'package:amutelecom/helpers/localtime_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:amutelecom/utils/colors.dart';

import '../controllers/transaction_controller.dart';

class TransactionsPage extends StatefulWidget {
  TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final box = GetStorage();

  final TextEditingController dateController = TextEditingController();

  LanguagesController languagesController = Get.put(LanguagesController());

  final transactionController = Get.find<TransactionController>();

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // transactionController.initialpage = 1;
    transactionController.finalList.clear();
    transactionController.fetchTransactionData();
    // scrollController.addListener(refresh);
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        transactionController.fetchMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.grey),
        ),
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.backgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          languagesController.tr("TRANSACTIONS"),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: AppColors.backgroundColor,
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: TextField(
                                controller: dateController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "dd/mm/yyyy",
                                  hintStyle: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {},
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
                              languagesController.tr("SEARCH"),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    languagesController.tr("ALL") +
                        " " +
                        languagesController.tr("TRANSACTIONS"),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Obx(
                () => transactionController.isLoading.value == true
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
                () => transactionController.isLoading.value == false
                    ? Container(
                        child:
                            transactionController
                                .alltransactionlist
                                .value
                                .data!
                                .resellerBalanceTransactions
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
                      transactionController.isLoading.value == false &&
                          transactionController.finalList.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: () async {
                            await transactionController.fetchTransactionData();
                          },
                          child: ListView.builder(
                            shrinkWrap: false,
                            controller: scrollController,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: transactionController.finalList.length,
                            itemBuilder: (context, index) {
                              final data =
                                  transactionController.finalList[index];
                              return Card(
                                elevation: 4,
                                margin: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 4,
                                ), // Spacing between cards
                                shadowColor: Colors.black12,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          // 1. Colored Status Strip (Left Side)
                                          Container(
                                            width: 6,
                                            color:
                                                data.status.toString() ==
                                                    "debit"
                                                ? Colors.red
                                                : Colors.green,
                                          ),

                                          // 2. Main Content Area
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                16.0,
                                              ),
                                              child: Column(
                                                spacing:
                                                    8.0, // Requires Flutter 3.24+, otherwise use SizedBox
                                                children: [
                                                  // --- Name Row ---
                                                  _buildInfoRow(
                                                    label: languagesController
                                                        .tr("NAME"),
                                                    value: data
                                                        .reseller!
                                                        .contactName
                                                        .toString(),
                                                    valueColor: Colors.black87,
                                                  ),

                                                  Divider(
                                                    height: 12,
                                                    thickness: 0.5,
                                                    color: Colors.grey[200],
                                                  ),

                                                  // --- Date Row ---
                                                  _buildInfoRow(
                                                    label: languagesController
                                                        .tr("DATE"),
                                                    value: convertToDate(
                                                      data.createdAt.toString(),
                                                    ),
                                                  ),

                                                  // --- Time Row ---
                                                  _buildInfoRow(
                                                    label: languagesController
                                                        .tr("TIME"),
                                                    value: convertToLocalTime(
                                                      data.createdAt.toString(),
                                                    ),
                                                  ),

                                                  // --- Type/Status Row ---
                                                  _buildInfoRow(
                                                    label: languagesController
                                                        .tr(
                                                          "TRANSACTIONS_TYPE",
                                                        ),
                                                    value:
                                                        data.status
                                                                .toString() ==
                                                            "debit"
                                                        ? languagesController
                                                              .tr("DEBIT")
                                                        : languagesController
                                                              .tr("CREDIT"),
                                                    valueColor:
                                                        data.status
                                                                .toString() ==
                                                            "debit"
                                                        ? Colors.red
                                                        : Colors.green,
                                                    isBold: true,
                                                  ),

                                                  Divider(
                                                    height: 12,
                                                    thickness: 0.5,
                                                    color: Colors.grey[200],
                                                  ),

                                                  // --- Amount Row (Highlighted) ---
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        languagesController.tr(
                                                          "AMOUNT",
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.grey[600],
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
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
                                                                data.amount
                                                                    .toString(),
                                                              ),
                                                            ),
                                                            style: TextStyle(
                                                              fontSize:
                                                                  18, // Larger font for amount
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  data.status
                                                                          .toString() ==
                                                                      "debit"
                                                                  ? Colors.red
                                                                  : Colors
                                                                        .green,
                                                            ),
                                                          ),
                                                          SizedBox(width: 4),
                                                          Text(
                                                            box.read(
                                                              "currency_code",
                                                            ),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    data.transactionReason
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize:
                                                          15, // Larger font for amount
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
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
                                ),
                              );
                            },
                          ),
                        )
                      : transactionController.finalList.isEmpty
                      ? SizedBox()
                      : RefreshIndicator(
                          onRefresh: () async {
                            await transactionController.fetchTransactionData();
                          },
                          child: ListView.builder(
                            shrinkWrap: false,
                            controller: scrollController,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: transactionController.finalList.length,
                            itemBuilder: (context, index) {
                              final data =
                                  transactionController.finalList[index];

                              return Card(
                                color: Colors.white,
                                child: Container(
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                    // color: Colors.grey,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(8),
                                          bottomRight: Radius.circular(8),
                                        ),
                                      ),
                                      child: Container(
                                        width: screenWidth,
                                        child: Column(
                                          spacing: 3.0,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  languagesController.tr(
                                                    "NAME",
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  data.reseller!.contactName
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  languagesController.tr(
                                                    "DATE",
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  convertToDate(
                                                    data.createdAt.toString(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  languagesController.tr(
                                                    "TIME",
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  convertToLocalTime(
                                                    data.createdAt.toString(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  languagesController.tr(
                                                    "TRANSACTIONS_TYPE",
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  data.status.toString() ==
                                                          "debit"
                                                      ? languagesController.tr(
                                                          "DEBIT",
                                                        )
                                                      : languagesController.tr(
                                                          "CREDIT",
                                                        ),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color:
                                                        data.status
                                                                .toString() ==
                                                            "debit"
                                                        ? Colors.red
                                                        : Colors.green,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  languagesController.tr(
                                                    "AMOUNT",
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      NumberFormat.currency(
                                                        locale: 'en_US',
                                                        symbol: '',
                                                        decimalDigits: 2,
                                                      ).format(
                                                        double.parse(
                                                          data.amount
                                                              .toString(),
                                                        ),
                                                      ),
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            data.status
                                                                    .toString() ==
                                                                "debit"
                                                            ? Colors.red
                                                            : Colors.green,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      "${box.read("currency_code")} ",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            data.status
                                                                    .toString() ==
                                                                "debit"
                                                            ? Colors.red
                                                            : Colors.green,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                  ),
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
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            color: valueColor ?? Colors.black87,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

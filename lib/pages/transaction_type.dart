import 'package:amutelecom/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/transaction_controller.dart';
import '../global_controller/languages_controller.dart';
import '../routes/routes.dart';
import '../screens/commission_transfer_screen.dart';
import '../screens/hawala_currency_screen.dart';
import '../screens/hawala_list_screen.dart';
import '../screens/loan_screen.dart';
import '../widgets/payment_button.dart';
import 'transactions.dart';

class TransactionsType extends StatefulWidget {
  TransactionsType({super.key});

  @override
  State<TransactionsType> createState() => _TransactionsTypeState();
}

class _TransactionsTypeState extends State<TransactionsType> {
  LanguagesController languagesController = Get.put(LanguagesController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
          languagesController.tr("TRANSACTIONS_TYPE"),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
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
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      PaymentButton(
                        buttonName: languagesController.tr(
                          "PAYMENT_RECEIPT_REQUEST",
                        ),
                        imagelink: "assets/icons/wallet.png",
                        mycolor: AppColors.defaultColor,
                        onpressed: () {
                          Get.toNamed(receiptScreen);
                        },
                      ),
                      SizedBox(height: 10),
                      PaymentButton(
                        buttonName: languagesController.tr(
                          "REQUES_LOAN_BALANCE",
                        ),
                        imagelink: "assets/icons/transactionsicon.png",
                        mycolor: AppColors.defaultColor,
                        onpressed: () {
                          Get.to(() => RequestLoanScreen());
                        },
                      ),
                      SizedBox(height: 10),
                      PaymentButton(
                        buttonName: languagesController.tr("HAWALA"),
                        imagelink: "assets/icons/exchange.png",
                        mycolor: AppColors.defaultColor,
                        onpressed: () {
                          Get.to(() => HawalaListScreen());
                        },
                      ),
                      SizedBox(height: 10),
                      PaymentButton(
                        buttonName: languagesController.tr("HAWALA_RATES"),
                        imagelink: "assets/icons/exchange-rate.png",
                        mycolor: AppColors.defaultColor,
                        onpressed: () {
                          Get.to(() => HawalaCurrencyScreen());
                        },
                      ),
                      SizedBox(height: 10),
                      PaymentButton(
                        buttonName: languagesController.tr(
                          "BALANCE_TRANSACTIONS",
                        ),
                        imagelink: "assets/icons/transactionsicon.png",
                        mycolor: AppColors.defaultColor,
                        onpressed: () {
                          Get.to(() => TransactionsPage());
                        },
                      ),
                      SizedBox(height: 10),
                      PaymentButton(
                        buttonName: languagesController.tr(
                          "TRANSFER_COMISSION_TO_BALANCE",
                        ),
                        imagelink: "assets/icons/transactionsicon2.png",
                        mycolor: AppColors.defaultColor,
                        onpressed: () {
                          Get.to(() => CommissionTransferScreen());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

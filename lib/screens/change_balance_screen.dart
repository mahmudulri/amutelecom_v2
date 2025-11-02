import 'package:amutelecom/global_controller/languages_controller.dart';
import 'package:amutelecom/widgets/auth_textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:amutelecom/controllers/change_balance_controller.dart';
import 'package:amutelecom/utils/colors.dart';
import 'package:amutelecom/widgets/default_button.dart';

class ChangeBalanceScreen extends StatefulWidget {
  final String? subID;
  ChangeBalanceScreen({super.key, this.subID});

  @override
  State<ChangeBalanceScreen> createState() => _ChangeBalanceScreenState();
}

class _ChangeBalanceScreenState extends State<ChangeBalanceScreen> {
  final BalanceController balanceController = Get.put(BalanceController());
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );
  final box = GetStorage();

  bool isCreditSelected = false;
  bool isDebitSelected = false;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          languagesController.tr("CHANGE_BALANCE"),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              languagesController.tr("AMOUNT"),
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            SizedBox(height: 10),
            // TextField(
            //   keyboardType: TextInputType.number,
            //   controller: balanceController.amountController,
            //   decoration: InputDecoration(
            //     hintText: languagesController.tr("ENTER_AMOUNT"),
            //     border:
            //         OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            //   ),
            // ),
            Container(
              height: 55,
              width: screenWidth,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppColors.borderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: balanceController.amountController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: languagesController.tr("ENTER_AMOUNT"),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              languagesController.tr("SELECT_TYPE"),
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildTypeButton(
                  languagesController.tr("CREDIT"),
                  isCreditSelected,
                  () {
                    setState(() {
                      balanceController.status.value = "credit";
                      isCreditSelected = true;
                      isDebitSelected = false;
                    });
                  },
                ),
                buildTypeButton(
                  languagesController.tr("DEBIT"),
                  isDebitSelected,
                  () {
                    setState(() {
                      balanceController.status.value = "debit";
                      isCreditSelected = false;
                      isDebitSelected = true;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Obx(
              () => DefaultButton(
                buttonName: balanceController.isLoading.value
                    ? languagesController.tr("PLEASE_WAIT")
                    : languagesController.tr("CONFIRM_NOW"),
                onPressed: balanceController.isLoading.value
                    ? null
                    : () {
                        if (balanceController.amountController.text.isEmpty ||
                            balanceController.status.value == '') {
                          Fluttertoast.showToast(
                            msg: languagesController.tr(
                              "ENTER_AMOUNT_OR_SELECT_TYPE",
                            ),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        } else {
                          balanceController.status.value == "credit"
                              ? balanceController.credit(
                                  widget.subID.toString(),
                                )
                              : balanceController.debit(
                                  widget.subID.toString(),
                                );
                        }
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTypeButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

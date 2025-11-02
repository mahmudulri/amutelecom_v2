import 'package:amutelecom/global_controller/languages_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:amutelecom/controllers/change_pin_controller.dart';
import 'package:amutelecom/widgets/auth_textfield.dart';
import 'package:amutelecom/widgets/default_button.dart';

class ChangePin extends StatelessWidget {
  ChangePin({super.key});

  final changePinController = Get.find<ChangePinController>();

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            languagesController.tr("CHANGE_PIN"),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languagesController.tr("OLD_PIN"),
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                SizedBox(height: 15),
                AuthTextField(
                  hintText: languagesController.tr("ENTER_YOUR_OLD_PIN"),
                  controller: changePinController.oldPinController,
                ),
                SizedBox(height: 15),
                Text(
                  languagesController.tr("NEW_PIN"),
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                SizedBox(height: 15),
                AuthTextField(
                  hintText: languagesController.tr("ENTER_YOUR_NEW_PIN"),
                  controller: changePinController.newPinController,
                ),
                // SizedBox(
                //   height: 15,
                // ),
                // Text(
                //   "Confirm Your Password: ",
                //   style: TextStyle(
                //     fontSize: 18,
                //     color: Colors.black,
                //   ),
                // ),
                // SizedBox(
                //   height: 15,
                // ),
                // AuthTextField(
                //   hintText: "Confirm password...",
                // ),
                SizedBox(height: 25),
                Obx(
                  () => DefaultButton(
                    buttonName: changePinController.isLoading.value == false
                        ? languagesController.tr("CHANGE")
                        : languagesController.tr("PLEASE_WAIT"),
                    onPressed: () {
                      if (changePinController.oldPinController.text.isEmpty ||
                          changePinController.newPinController.text.isEmpty) {
                        Fluttertoast.showToast(
                          msg: languagesController.tr("FILL_THE_DATA"),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      } else {
                        changePinController.change();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

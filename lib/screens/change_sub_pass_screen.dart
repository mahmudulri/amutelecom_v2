import 'package:amutelecom/controllers/language_controller.dart';
import 'package:amutelecom/global_controller/languages_controller.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:amutelecom/widgets/auth_textfield.dart';
import 'package:amutelecom/widgets/default_button.dart';

import '../controllers/sub_reseller_password_controller.dart';

class ChangeSubPasswordScreen extends StatelessWidget {
  String? subID;
  ChangeSubPasswordScreen({super.key, this.subID});

  final SubresellerPassController passwordConttroller = Get.put(
    SubresellerPassController(),
  );

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
          languagesController.tr("CHANGE_PASSWORD"),
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
                languagesController.tr("NEW_PASSWORD"),
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 15),
              AuthTextField(
                hintText: languagesController.tr("ENTER_YOUR_NEW_PASSWORD"),
                controller: passwordConttroller.newpassController,
              ),
              SizedBox(height: 15),
              Text(
                languagesController.tr("CONFIRM_PASSWORD"),
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 15),
              AuthTextField(
                hintText: languagesController.tr("CONFIRM_PASSWORD"),
                controller: passwordConttroller.confirmpassController,
              ),
              SizedBox(height: 25),
              Obx(
                () => DefaultButton(
                  buttonName: passwordConttroller.isLoading.value == false
                      ? languagesController.tr("CHANGE")
                      : languagesController.tr("PLEASE_WAIT"),
                  onPressed: () {
                    if (passwordConttroller.newpassController.text.isEmpty ||
                        passwordConttroller
                            .confirmpassController
                            .text
                            .isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Fill the data",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    } else {
                      passwordConttroller.change(subID);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:amutelecom/global_controller/languages_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:amutelecom/controllers/country_list_controller.dart';
import 'package:amutelecom/controllers/history_controller.dart';
import 'package:amutelecom/controllers/language_controller.dart';
import 'package:amutelecom/controllers/sign_in_controller.dart';
import 'package:amutelecom/helpers/language_helper.dart';
import 'package:amutelecom/routes/routes.dart';
import 'package:amutelecom/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class OldSignInScreen extends StatefulWidget {
  OldSignInScreen({super.key});

  @override
  State<OldSignInScreen> createState() => _OldSignInScreenState();
}

class _OldSignInScreenState extends State<OldSignInScreen> {
  final signInController = Get.find<SignInController>();
  final historyController = Get.find<HistoryController>();
  final countryListController = Get.find<CountryListController>();

  final languageController = Get.find<LanguagesController>();
  final box = GetStorage();

  whatsapp() async {
    var contact = "+93745295227";
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      print("not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/authback.jpg"),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              SizedBox(height: 100),
              Text(
                "Pamir Telecom",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 50),
              ClipPath(
                clipper: SideCutClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.defaultColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 210,
                  width: screenWidth,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              languageController.tr("ENTER_YOUR_CREDENTIAL"),
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: signInController.usernameController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: languageController.tr("USERNAME"),
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white54,
                                ),
                                suffixIcon: Icon(
                                  Icons.person_2_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            TextField(
                              controller: signInController.passwordController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: languageController.tr("PASSWORD"),
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white54,
                                ),
                                suffixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  historyController.initialpage = 1;

                  // languageController.fetchlanData(box.read("isoCode"));

                  if (signInController.usernameController.text.isEmpty ||
                      signInController.passwordController.text.isEmpty) {
                    Get.snackbar(
                      "Oops!",
                      "Fill the text fields",
                      colorText: Colors.white,
                      duration: Duration(seconds: 1),
                    );
                  } else {
                    await signInController.signIn();

                    if (signInController.loginsuccess.value == false) {
                      // Navigating to the BottomNavigationbar page
                      countryListController.fetchCountryData();
                      Get.toNamed(newbasescreen);

                      if (box.read("direction") == "rtl") {
                        setState(() {
                          EasyLocalization.of(
                            context,
                          )!.setLocale(Locale('ar', 'AE'));
                        });
                      } else {
                        setState(() {
                          EasyLocalization.of(
                            context,
                          )!.setLocale(Locale('en', 'US'));
                        });
                      }
                    } else {
                      print("Navigation conditions not met.");
                    }
                  }
                },
                child: Container(
                  height: 50,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Obx(
                      () => Text(
                        signInController.isLoading.value == false
                            ? languageController.tr("SIGN_IN")
                            : languageController.tr("PLEASE_WAIT"),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              whatsapp();
                            },
                            child: Container(
                              height: 30,
                              child: Image.asset("assets/icons/whatsapp.png"),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            languageController.tr("SUPPORT"),
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    languageController.tr("FORGOT_PASSWORD"),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    languageController.tr("DONT_HAVE_AN_ACCOUNT"),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(signupscreen);
                    },
                    child: Text(
                      languageController.tr("SIGN_UP"),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

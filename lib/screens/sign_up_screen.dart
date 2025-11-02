import 'dart:io';

import 'package:amutelecom/global_controller/languages_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:amutelecom/helpers/language_helper.dart';
import 'package:amutelecom/utils/colors.dart';
import 'package:amutelecom/widgets/default_button.dart';
import 'package:amutelecom/widgets/social_button.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/auth_textfield.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final languageController = Get.find<LanguagesController>();
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
                  height: 300,
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
                            SizedBox(height: 25),
                            TextField(
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
                            SizedBox(height: 15),
                            TextField(
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
                            SizedBox(height: 20),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [
                            //     Text(
                            //       "Forgot Password ?",
                            //       style: TextStyle(
                            //         fontWeight: FontWeight.w400,
                            //         color: Colors.white54,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            SizedBox(height: 25),
                            Container(
                              height: 50,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Center(
                                child: Text(
                                  languageController.tr("SIGN_UP"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(height: 40),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       getText("FORGOT_PASSWORD",
              //           defaultValue: "Forgot Password ?"),
              //       style: TextStyle(
              //         color: Colors.white,
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    languageController.tr("ALREADY_HAVE_AN_ACCOUNT"),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      languageController.tr("SIGN_IN"),
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

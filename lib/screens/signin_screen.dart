import 'dart:io';
import 'package:amutelecom/global_controller/languages_controller.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:amutelecom/controllers/country_list_controller.dart';
import 'package:amutelecom/controllers/dashboard_controller.dart';
import 'package:amutelecom/controllers/history_controller.dart';
import 'package:amutelecom/controllers/language_controller.dart';
import 'package:amutelecom/controllers/sign_in_controller.dart';
import 'package:amutelecom/helpers/language_helper.dart';
import 'package:amutelecom/routes/routes.dart';
import 'package:amutelecom/utils/colors.dart';
import 'package:amutelecom/widgets/auth_textfield.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final signInController = Get.find<SignInController>();
  final historyController = Get.find<HistoryController>();
  final countryListController = Get.find<CountryListController>();
  // final LanguageController languageController = Get.put(LanguageController());
  LanguagesController languagesController = Get.put(LanguagesController());
  // final dashboardController = Get.find<DashboardController>();

  final box = GetStorage();

  whatsapp() async {
    var contact = "+93728805094";
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    Future<bool> showExitPopup() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Exit App'),
              content: Text('Do you want to exit an App?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text('No'),
                ),
                ElevatedButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  //return true when click on "Yes"
                  child: Text('Yes'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showExitPopup();
        return shouldExit;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            height: screenHeight,
            width: screenWidth,
            child: ListView(
              children: [
                ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      // color: Colors.red,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/sign_in_back.jpg"),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage("assets/icons/logo.png"),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome back",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Obx(
                        () => Center(
                          child: TextField(
                            controller: signInController.usernameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: languagesController.tr("USERNAME"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    height: 55,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Obx(
                        () => Center(
                          child: TextField(
                            controller: signInController.passwordController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: languagesController.tr("PASSWORD"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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

                            historyController.finalList.clear();
                            historyController.initialpage = 1;
                            historyController.fetchHistory();
                            countryListController.printAfghanistanDetails();

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
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Center(
                            child: Obx(
                              () => Text(
                                signInController.isLoading.value == false
                                    ? languagesController.tr("LOGIN")
                                    : languagesController.tr("PLEASE_WAIT"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 30),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       GestureDetector(
                //         onTap: () {
                //           whatsapp();
                //         },
                //         child: Container(
                //           height: 30,
                //           width: 30,
                //           child: Image.asset("assets/icons/whatsapp.png"),
                //         ),
                //       ),
                //       SizedBox(
                //         width: 15,
                //       ),
                //       Text(
                //         getText("NEED_HELP", defaultValue: "Need Help"),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Made by : Woosat",
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                        Text(
                          "www.woosat.com",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
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
    );
  }
}

import 'package:amutelecom/controllers/country_list_controller.dart';
import 'package:amutelecom/controllers/history_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:amutelecom/controllers/slider_controller.dart';
import 'package:amutelecom/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:amutelecom/controllers/iso_code_controller.dart';
import 'package:amutelecom/controllers/language_controller.dart';
import 'package:amutelecom/utils/colors.dart';
import 'global_controller/languages_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () => checkData());

    super.initState();
  }

  LanguagesController languagesController = Get.put(LanguagesController());

  final sliderController = Get.find<SliderController>();

  final historyController = Get.find<HistoryController>();
  final countryListController = Get.find<CountryListController>();

  checkData() async {
    box.write("country_id", "2");
    box.write("maxlength", "10");
    // Default language is now English
    String languageShortName = box.read("language") ?? "En";

    // Find selected language details from the list
    final matchedLang = languagesController.alllanguagedata.firstWhere(
      (lang) => lang["name"] == languageShortName,
      orElse: () => {"isoCode": "en", "direction": "ltr"},
    );

    final isoCode = matchedLang["isoCode"] ?? "en";
    final direction = matchedLang["direction"] ?? "ltr";

    box.write("language", languageShortName);
    box.write("direction", direction);

    languagesController.changeLanguage(languageShortName);

    Locale locale;
    switch (isoCode) {
      case "fa":
        locale = Locale("fa", "IR");
        break;
      case "en":
        locale = Locale("en", "US");
        break;
      case "ar":
        locale = Locale("ar", "AE");
        break;
      case "ps":
        locale = Locale("ps", "AF");
        break;
      case "tr":
        locale = Locale("tr", "TR");
        break;
      case "bn":
        locale = Locale("bn", "BD");
        break;
      default:
        locale = Locale("en", "US");
    }

    setState(() {
      EasyLocalization.of(context)!.setLocale(locale);
    });

    // If no token, go to onboarding
    if (box.read('userToken') == null) {
      Get.toNamed(signinscreen);
    } else {
      // Fetch initial data
      countryListController.printAfghanistanDetails();
      sliderController.fetchSliderData();
      box.write("orderstatus", "");
      historyController.finalList.clear();
      historyController.initialpage = 1;
      historyController.fetchHistory();
      Get.toNamed(newbasescreen);
    }
  }

  dcheckData() async {
    box.write("country_id", "2");
    box.write("maxlength", "10");
    if (box.read('userToken') == null) {
      if (box.read("isoCode") == null) {
        box.write("isoCode", "en");
        box.write("direction", "ltr");

        // languageController.fetchlanData("en");
        languagesController.changeLanguage("en");

        // setState(() {
        //   EasyLocalization.of(context)!.setLocale(Locale('en', 'US'));
        // });
        Get.toNamed(signinscreen);
      } else {
        if (box.read("isoCode") == "en") {
          box.write("direction", "ltr");
          // languageController.fetchlanData("en");

          languagesController.changeLanguage("en");

          // setState(() {
          //   EasyLocalization.of(context)!.setLocale(Locale('en', 'US'));
          // });
          Get.toNamed(signinscreen);
        } else {
          box.write("direction", "rtl");
          // languageController.fetchlanData("fa");
          languagesController.changeLanguage("fa");
          setState(() {
            EasyLocalization.of(context)!.setLocale(Locale('ar', 'AE'));
          });
          Get.toNamed(signinscreen);
        }
      }
    } else {
      languagesController.changeLanguage(box.read("isoCode"));
      // languageController.fetchlanData(box.read("isoCode"));

      if (box.read("direction") == "rtl") {
        setState(() {
          EasyLocalization.of(context)!.setLocale(Locale('ar', 'AE'));
        });
      } else {
        print("Eng format");
      }
      countryListController.printAfghanistanDetails();
      sliderController.fetchSliderData();
      box.write("orderstatus", "");
      historyController.finalList.clear();
      historyController.initialpage = 1;
      historyController.fetchHistory();
      Get.toNamed(newbasescreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor:
            AppColors.defaultColor, // Optional: makes status bar transparent
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.defaultColor,
      // backgroundColor: Color(0xffD2D2D2),
      body: Center(
        child: GestureDetector(
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "WELCOME TO",
                style: GoogleFonts.bebasNeue(
                  // color: Color(0xff46558A),
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Amu Telecom",
                style: GoogleFonts.bebasNeue(
                  // color: Color(0xff46558A),
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
              Lottie.asset(
                'assets/loties/loading-02.json',
                height: 200,
                width: 200,
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

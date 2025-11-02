import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/time_zone_controller.dart';
import 'routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await GetStorage.init();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyD0FlqyjzJCHVSpuRr4CXn35H8IUkeYZiM",
      authDomain: "afghannetwoosat.firebaseapp.com",
      projectId: "afghannetwoosat",
      storageBucket: "afghannetwoosat.firebasestorage.app",
      messagingSenderId: "538583955286",
      appId: "1:538583955286:web:f4775e20a0d17a7bbc88f7",
    ),
  );
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('fa', 'IR'),
        Locale('ar', 'AE'),
        Locale('ps', 'AF'),
        Locale('tr', 'TR'),
        Locale('bn', 'BD'),
      ],
      path: 'assets/langs',
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(),
    ),
  );

  //// used for check real time internet access
  // DependencyInjection.init();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = GetStorage();
  final TimeZoneController timeZoneController = Get.put(TimeZoneController());
  @override
  void initState() {
    super.initState();
    _initTimezone();
  }

  Future<void> _initTimezone() async {
    try {
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();

      print('TimezoneInfo object: $timezoneInfo');

      timeZoneController.myzone = timezoneInfo.toString();

      // Apply your offset logic
      timeZoneController.setTimezoneOffset();
      timeZoneController.extractTimeDetails();

      print('Detected Timezone: ${timeZoneController.myzone}');
      print(
        'UTC Offset: ${timeZoneController.sign}${timeZoneController.hour}:${timeZoneController.minute}',
      );
    } catch (e) {
      print('Error getting timezone: $e');
      timeZoneController.myzone = 'UTC';
      timeZoneController.setTimezoneOffset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: splash,
      getPages: myroutes,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Schedule locale update after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.updateLocale(context.locale);
    });
  }
}

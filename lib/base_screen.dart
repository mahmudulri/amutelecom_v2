import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:amutelecom/controllers/country_list_controller.dart';
import 'package:amutelecom/controllers/history_controller.dart';
import 'package:amutelecom/controllers/language_controller.dart';
import 'package:amutelecom/controllers/order_list_controller.dart';
import 'package:amutelecom/controllers/transaction_controller.dart';
import 'package:amutelecom/controllers/dashboard_controller.dart';
import 'package:amutelecom/pages/homepage.dart';
import 'package:amutelecom/pages/sub_reseller_screen.dart';
import 'package:amutelecom/utils/colors.dart';
import 'global_controller/languages_controller.dart';
import 'pages/myaccount.dart';

class NewBaseScreen extends StatefulWidget {
  const NewBaseScreen({super.key});

  @override
  State<NewBaseScreen> createState() => _NewBaseScreenState();
}

class _NewBaseScreenState extends State<NewBaseScreen>
    with SingleTickerProviderStateMixin {
  List<Widget> pages = [Homepage(), SubResellerScreen(), MyaccountScreen()];

  final box = GetStorage();
  int currentIndex = 0;

  // final historyController = Get.find<HistoryController>();
  final transactionController = Get.find<TransactionController>();
  final countryListController = Get.find<CountryListController>();
  final orderlistController = Get.find<OrderlistController>();
  final dashboardController = Get.find<DashboardController>();

  final historyController = Get.find<HistoryController>();

  LanguagesController languagesController = Get.put(LanguagesController());

  Animation<double>? _animation;
  AnimationController? _animationController;

  @override
  void initState() {
    countryListController.fetchCountryData();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController!,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppColors.defaultColor,
      ),
    );
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit the app?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showExitPopup();
        return shouldExit;
      },
      child: Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            elevation: 2.0,
            selectedItemColor: Colors.green,
            // type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
                if (index == 0) {
                  dashboardController.fetchDashboardData();
                  countryListController.printAfghanistanDetails();
                  historyController.finalList.clear();
                  historyController.initialpage = 1;
                  historyController.fetchHistory();
                } else {
                  print("object");
                }
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: languagesController.tr("HOME"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: languagesController.tr("SUB_RESELLER"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: languagesController.tr("ACCOUNT"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

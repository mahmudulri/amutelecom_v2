import 'package:amutelecom/bindings/add_sub_reseller_binding.dart';
import 'package:amutelecom/bindings/baseview_binding.dart';
import 'package:amutelecom/bindings/custom_recharge_binding.dart';
import 'package:amutelecom/bindings/myprofile_binding.dart';
import 'package:amutelecom/bindings/orders_binding.dart';
import 'package:amutelecom/bindings/recharge_binding.dart';
import 'package:amutelecom/bindings/sign_in_binding.dart';
import 'package:amutelecom/bindings/splash_binding.dart';
import 'package:amutelecom/bindings/transaction_binding.dart';
import 'package:amutelecom/base_screen.dart';
import 'package:amutelecom/pages/orders.dart';
import 'package:amutelecom/pages/transactions.dart';
import 'package:amutelecom/screens/add_card_screen.dart';
import 'package:amutelecom/screens/add_sub_reseller_screen.dart';
import 'package:amutelecom/screens/custom_recharge_screen.dart';
import 'package:amutelecom/screens/new_confirmpin_screen.dart';
import 'package:amutelecom/screens/signin_screen.dart';
import 'package:amutelecom/screens/change_balance_screen.dart';
import 'package:amutelecom/screens/change_pin.dart';
import 'package:amutelecom/screens/change_sub_pass_screen.dart';
import 'package:amutelecom/screens/confirm_pin.dart';
import 'package:amutelecom/screens/edit_profile_screen.dart';
import 'package:amutelecom/screens/myprofile_screen.dart';
import 'package:amutelecom/screens/onboarding.dart';
import 'package:amutelecom/screens/order_details.dart';
import 'package:amutelecom/screens/recharge_screen.dart';
import 'package:amutelecom/screens/result_screen.dart';
import 'package:amutelecom/screens/sign_up_screen.dart';
import 'package:amutelecom/screens/social_recharge.dart';
import 'package:get/get.dart';
import 'package:amutelecom/screens/welcome_screen.dart';
import 'package:amutelecom/splash_screen.dart';

import '../bindings/receipt_binding.dart';
import '../pages/transaction_type.dart';
import '../screens/create_payments_screen.dart';
import '../screens/custom_result_screen.dart';
import '../screens/receipts_screen.dart';

const String splash = '/splash-screen';
const String welcomescreen = '/welcome-screen';
const String signinscreen = '/signin-screen';
const String signupscreen = '/signup-screen';
const String onboardingscreen = '/onboardin-screen';
const String basescreen = '/base-screen';
const String newbasescreen = '/newbase-screen';
const String addcardScreen = '/addcard-screen';
const String addsubresellerscreen = '/addsubreseller-screen';
const String changebalancescreen = '/changebalance-screen';
const String changepinscreen = '/changepin-screen';
const String changesubpassscreen = '/changesubpass-screen';
const String confirmpinscreen = '/confirmpin-screen';
const String newconfirmpinscreen = '/newconfirmpin-screen';
const String editprofilescreen = '/editprofile-screen';
const String myprofilescreen = '/myprofile-screen';
const String orderdetailsscreen = '/orderdetails-screen';
const String rechargescreen = '/recharge-screen';
const String customrechargescreen = '/customrecharge-screen';
const String resultscreen = '/result-screen';
const String customresultscreen = '/customresult-screen';
const String servicescreen = '/service-screen';
const String ordersscreen = '/orders-screen';
const String transactionscreen = '/transaction-screen';
const String socialrechargescreen = '/socialrecharge-screen';
const String mydraftscreen = '/mydraftscreen';
const String transactiontypescreen = '/transactiontype-screen';
const String helpscreen = '/help-screen';
const String receiptScreen = '/receipt-screen';
const String createpaymentScreen = '/createpayment-screen';
const String changepasswordScreen = '/changepassword-screen';

List<GetPage> myroutes = [
  GetPage(name: splash, page: () => SplashScreen(), binding: SplashBinding()),
  GetPage(
    name: welcomescreen,
    page: () => WelcomeScreen(),
    // binding: SplashBinding(),
  ),
  GetPage(
    name: signinscreen,
    page: () => SignInScreen(),
    binding: SignInBinding(),
  ),
  GetPage(
    name: signupscreen,
    page: () => SignUpScreen(),
    // binding: SplashBinding(),
  ),
  GetPage(
    name: newbasescreen,
    page: () => NewBaseScreen(),
    binding: BaseViewBinding(),
  ),
  GetPage(
    name: onboardingscreen,
    page: () => Onboarding(),
    binding: SignInBinding(),
  ),
  GetPage(name: addcardScreen, page: () => AddCardScreen()),
  GetPage(
    name: addsubresellerscreen,
    page: () => AddSubResellerScreen(),
    binding: AddSubResellerBinding(),
  ),
  GetPage(name: changebalancescreen, page: () => ChangeBalanceScreen()),
  GetPage(name: changepinscreen, page: () => ChangePin()),
  GetPage(name: changesubpassscreen, page: () => ChangeSubPasswordScreen()),
  GetPage(name: confirmpinscreen, page: () => ConfirmPinScreen()),
  GetPage(name: newconfirmpinscreen, page: () => NewConfirmpinScreen()),
  GetPage(name: editprofilescreen, page: () => EditProfileScreen()),
  GetPage(
    name: myprofilescreen,
    page: () => MyprofileScreen(),
    binding: MyProfileBinding(),
  ),
  GetPage(name: orderdetailsscreen, page: () => OrderDetailsScreen()),
  GetPage(
    name: rechargescreen,
    page: () => RechargeScreen(),
    binding: RechargeBinding(),
  ),
  GetPage(
    name: customrechargescreen,
    page: () => CustomRechargeScreen(),
    binding: CustomRechargeBinding(),
  ),
  GetPage(name: resultscreen, page: () => ResultScreen()),
  GetPage(name: customresultscreen, page: () => CustomResultScreen()),
  GetPage(
    name: ordersscreen,
    page: () => OrdersPage(),
    binding: OrdersBinding(),
  ),
  GetPage(
    name: transactionscreen,
    page: () => TransactionsPage(),
    binding: TransactionBinding(),
  ),
  GetPage(
    name: socialrechargescreen,
    page: () => SocialRechargeScreen(),
    binding: RechargeBinding(),
  ),
  GetPage(name: transactiontypescreen, page: () => TransactionsType()),
  // GetPage(
  //   name: helpscreen,
  //   page: () => Helpscreen(),
  //   binding: BottomNavBinding(),
  // ),
  GetPage(
    name: receiptScreen,
    page: () => ReceiptsScreen(),
    binding: ReceiptBinding(),
  ),
  GetPage(name: createpaymentScreen, page: () => CreatePaymentsScreen()),
  // GetPage(
  //   name: changepasswordScreen,
  //   page: () => ChangePasswordScreen(),
  // ),
];

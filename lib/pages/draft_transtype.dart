import 'package:amutelecom/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/transaction_controller.dart';
import '../global_controller/languages_controller.dart';
import '../routes/routes.dart';
import '../screens/commission_transfer_screen.dart';
import '../screens/hawala_currency_screen.dart';
import '../screens/hawala_list_screen.dart';
import '../screens/loan_screen.dart';
import '../widgets/payment_button.dart';
import 'transactions.dart';

class TransactionsType extends StatefulWidget {
  TransactionsType({super.key});

  @override
  State<TransactionsType> createState() => _TransactionsTypeState();
}

class _TransactionsTypeState extends State<TransactionsType> {
  LanguagesController languagesController = Get.put(LanguagesController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black87,
              size: 18,
            ),
          ),
        ),
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          languagesController.tr("TRANSACTIONS_TYPE"),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Text(
                  languagesController.tr("SELECT_TRANSACTION") ??
                      "Select Transaction",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),

                // Transaction Options Grid
                _buildTransactionGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionGrid() {
    final transactions = [
      {
        'title': languagesController.tr("PAYMENT_RECEIPT_REQUEST"),
        'icon': Icons.receipt_long_rounded,
        'gradient': [Color(0xFF667eea), Color(0xFF764ba2)],
        'onTap': () => Get.toNamed(receiptScreen),
      },
      {
        'title': languagesController.tr("REQUES_LOAN_BALANCE"),
        'icon': Icons.account_balance_wallet_rounded,
        'gradient': [Color(0xFFf093fb), Color(0xFFf5576c)],
        'onTap': () => Get.to(() => RequestLoanScreen()),
      },
      {
        'title': languagesController.tr("HAWALA"),
        'icon': Icons.swap_horiz_rounded,
        'gradient': [Color(0xFF4facfe), Color(0xFF00f2fe)],
        'onTap': () => Get.to(() => HawalaListScreen()),
      },
      {
        'title': languagesController.tr("HAWALA_RATES"),
        'icon': Icons.currency_exchange_rounded,
        'gradient': [Color(0xFF43e97b), Color(0xFF38f9d7)],
        'onTap': () => Get.to(() => HawalaCurrencyScreen()),
      },
      {
        'title': languagesController.tr("BALANCE_TRANSACTIONS"),
        'icon': Icons.history_rounded,
        'gradient': [Color(0xFFfa709a), Color(0xFFfee140)],
        'onTap': () => Get.to(() => TransactionsPage()),
      },
      {
        'title': languagesController.tr("TRANSFER_COMISSION_TO_BALANCE"),
        'icon': Icons.transform_rounded,
        'gradient': [Color(0xFF30cfd0), Color(0xFF330867)],
        'onTap': () => Get.to(() => CommissionTransferScreen()),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.95,
      ),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionCard(
          title: transaction['title'] as String,
          icon: transaction['icon'] as IconData,
          gradient: transaction['gradient'] as List<Color>,
          onTap: transaction['onTap'] as VoidCallback,
        );
      },
    );
  }

  Widget _buildTransactionCard({
    required String title,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Container with Gradient
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: gradient[0].withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(icon, size: 32, color: Colors.white),
              ),
              const SizedBox(height: 16),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.3,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

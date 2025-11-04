import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/hawala_currency_controller.dart';
import '../global_controller/languages_controller.dart';
import '../utils/colors.dart';

class HawalaCurrencyScreen extends StatefulWidget {
  const HawalaCurrencyScreen({super.key});

  @override
  State<HawalaCurrencyScreen> createState() => _HawalaCurrencyScreenState();
}

class _HawalaCurrencyScreenState extends State<HawalaCurrencyScreen> {
  final box = GetStorage();

  HawalaCurrencyController hawalacurrencycontroller = Get.put(
    HawalaCurrencyController(),
  );
  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  void initState() {
    super.initState();
    hawalacurrencycontroller.fetchcurrency();
  }

  final Color headerBg = AppColors.defaultColor;
  final Color headerText = Colors.white;
  final Color stripeLight = Colors.white;
  final Color stripeTint = AppColors.defaultColor.withOpacity(0.04);
  final Color hoverTint = AppColors.defaultColor.withOpacity(0.08);
  final Color selectTint = AppColors.defaultColor.withOpacity(0.15);
  final Color borderColor = AppColors.defaultColor;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.grey),
        ),
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          languagesController.tr("HAWALA_RATES"),
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
        decoration: BoxDecoration(),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => hawalacurrencycontroller.isLoading.value == false
                      ? SingleChildScrollView(
                          // vertical scroll only, as you had
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: borderColor, width: 1),
                            ),
                            margin: EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: DataTableTheme(
                                data: DataTableThemeData(
                                  headingRowColor: MaterialStateProperty.all(
                                    headerBg,
                                  ),
                                  headingTextStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    letterSpacing: 0.3,
                                  ),
                                  dataTextStyle: TextStyle(
                                    fontSize: 12,
                                    height: 1.2,
                                  ),
                                  dividerThickness: 1,
                                  horizontalMargin: 12,
                                  columnSpacing: 12,
                                ),
                                child: DataTable(
                                  showCheckboxColumn: false,
                                  headingRowHeight: 40,
                                  dataRowMinHeight: 36,
                                  dataRowMaxHeight: 44,
                                  border: TableBorder(
                                    horizontalInside: BorderSide(
                                      color: borderColor.withOpacity(0.25),
                                      width: 1,
                                    ),
                                    verticalInside: BorderSide(
                                      color: borderColor.withOpacity(0.15),
                                      width: 1,
                                    ),
                                    top: BorderSide(
                                      color: borderColor,
                                      width: 1,
                                    ),
                                    bottom: BorderSide(
                                      color: borderColor,
                                      width: 1,
                                    ),
                                    left: BorderSide(
                                      color: borderColor,
                                      width: 1,
                                    ),
                                    right: BorderSide(
                                      color: borderColor,
                                      width: 1,
                                    ),
                                  ),
                                  columns: [
                                    DataColumn(
                                      label: Expanded(
                                        child: Center(
                                          child: Text(
                                            languagesController.tr("AMOUNT"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: headerText,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Center(
                                          child: Text(
                                            languagesController.tr("FROM"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: headerText,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Center(
                                          child: Text(
                                            languagesController.tr("TO"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: headerText,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Center(
                                          child: Text(
                                            languagesController.tr("BUY"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: headerText,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Center(
                                          child: Text(
                                            languagesController.tr("SELL"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: headerText,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: List<DataRow>.generate(
                                    hawalacurrencycontroller
                                            .allcurrencylist
                                            .value
                                            .data
                                            ?.rates
                                            ?.length ??
                                        0,
                                    (i) {
                                      final data = hawalacurrencycontroller
                                          .allcurrencylist
                                          .value
                                          .data!
                                          .rates![i];
                                      final isEven = i.isEven;

                                      return DataRow(
                                        color:
                                            MaterialStateProperty.resolveWith<
                                              Color?
                                            >((states) {
                                              if (states.contains(
                                                MaterialState.selected,
                                              )) {
                                                return selectTint;
                                              }
                                              if (states.contains(
                                                MaterialState.hovered,
                                              )) {
                                                return hoverTint;
                                              }
                                              return isEven
                                                  ? stripeLight
                                                  : stripeTint;
                                            }),
                                        // If you don't need row selection visuals, you can remove this line.
                                        onSelectChanged: (_) {},
                                        cells: [
                                          DataCell(
                                            Center(
                                              child: Text(
                                                data.amount.toString(),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                data.fromCurrency?.name ?? "-",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                data.toCurrency?.name ?? "-",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                "${data.buyRate ?? '-'} ${data.toCurrency?.symbol ?? ''}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                "${data.sellRate ?? '-'} ${data.toCurrency?.symbol ?? ''}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

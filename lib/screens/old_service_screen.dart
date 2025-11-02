import 'package:amutelecom/controllers/bundles_controller.dart';
import 'package:amutelecom/controllers/categories_list_controller.dart';
import 'package:amutelecom/controllers/country_list_controller.dart';
import 'package:amutelecom/controllers/reserve_digit_controller.dart';
import 'package:amutelecom/controllers/service_controller.dart';
import 'package:amutelecom/global_controller/languages_controller.dart';
import 'package:amutelecom/routes/routes.dart';
import 'package:amutelecom/screens/social_recharge.dart';
import 'package:amutelecom/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/language_controller.dart';
import 'recharge_screen.dart';

class OldNewServiceScreen extends StatelessWidget {
  OldNewServiceScreen({super.key});

  final languageController = Get.find<LanguagesController>();
  final categorisListController = Get.find<CategorisListController>();

  final box = GetStorage();

  final countryListController = Get.find<CountryListController>();
  final bundleController = Get.find<BundleController>();

  final serviceController = Get.find<ServiceController>();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffEFF3F4),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        backgroundColor: Color(0xffEFF3F4),
        elevation: 0.0,
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            categorisListController.fetchcategories();
          },
          child: Text(
            languageController.tr("SERVICES"),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Container(
        color: Color(0xffEFF3F4),
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Obx(
            () =>
                categorisListController.isLoading.value == false &&
                    countryListController.isLoading.value == false
                ? ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      // Display Nonsocial Service Categories by Country
                      ...countryListController
                          .allcountryListData
                          .value
                          .data!
                          .countries
                          .map((country) {
                            final nonsocialCategories = categorisListController
                                .allcategorieslist
                                .value!
                                .data!
                                .servicecategories!
                                .where(
                                  (category) => category.type == "nonsocial",
                                )
                                .toList();

                            final countries = countryListController
                                .allcountryListData
                                .value
                                .data
                                ?.countries;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Text(
                                //   "${country.countryName} Network",
                                //   style: TextStyle(
                                //     fontSize: 15,
                                //     fontWeight: FontWeight.bold,
                                //     color: Colors.black,
                                //   ),
                                // ),
                                SizedBox(height: 5),
                                Container(
                                  height: 125,
                                  width: screenWidth,
                                  child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: nonsocialCategories.length,
                                    itemBuilder: (context, catIndex) {
                                      final category =
                                          nonsocialCategories[catIndex];
                                      return GestureDetector(
                                        onTap: () {
                                          serviceController.reserveDigit
                                              .clear();

                                          box.write(
                                            "maxlength",
                                            country.phoneNumberLength
                                                .toString(),
                                          );

                                          bundleController.finalList.clear();
                                          box.write("validity_type", "");
                                          box.write("company_id", "");
                                          box.write("search_tag", "");
                                          box.write(
                                            "country_id",
                                            country.id.toString(),
                                          );

                                          box.write(
                                            "service_category_id",
                                            category.id.toString(),
                                          );
                                          bundleController.initialpage = 1;

                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         RechargeScreen(),
                                          //   ),
                                          // );

                                          ///////.....................................//
                                          // print(box.read("country_id"));
                                          // print(box.read("service_category_id"));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 5),
                                          width: 175,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                  0.2,
                                                ),
                                                spreadRadius: 2,
                                                blurRadius: 2,
                                                offset: Offset(0, 0),
                                              ),
                                            ],
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // Text(
                                              //   "${country.id}",
                                              //   style: TextStyle(
                                              //     fontSize: 8,
                                              //     fontWeight: FontWeight.bold,
                                              //     color: Colors.black,
                                              //   ),
                                              // ),
                                              CircleAvatar(
                                                radius: 30,
                                                backgroundColor: Colors.white,
                                                backgroundImage: NetworkImage(
                                                  country.countryFlagImageUrl
                                                      .toString(),
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              // Text(
                                              //   category.id.toString(),
                                              //   textAlign: TextAlign.center,
                                              //   style: TextStyle(
                                              //     fontSize: 10,
                                              //     color: Colors.black,
                                              //     fontWeight: FontWeight.bold,
                                              //   ),
                                              // ),
                                              Text(
                                                category.categoryName
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          })
                          .toList(),
                      // Display Social Service Categories without Country
                      ...categorisListController
                          .allcategorieslist
                          .value!
                          .data!
                          .servicecategories!
                          .where((category) => category.type == "social")
                          .map((category) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.categoryName.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 3.0,
                                        mainAxisSpacing: 3.0,
                                        childAspectRatio: 0.9,
                                      ),
                                  itemCount: category.services?.length ?? 0,
                                  itemBuilder: (context, serviceIndex) {
                                    final service =
                                        category.services![serviceIndex];
                                    return GestureDetector(
                                      onTap: () {
                                        bundleController.finalList.clear();
                                        // print(service.companyId.toString());
                                        box.write("validity_type", "");
                                        box.write(
                                          "company_id",
                                          service.companyId.toString(),
                                        );
                                        box.write("search_tag", "");
                                        box.write(
                                          "country_id",
                                          service.company!.countryId.toString(),
                                        );

                                        box.write(
                                          "service_category_id",
                                          category.id.toString(),
                                        );
                                        bundleController.initialpage = 1;

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SocialRechargeScreen(),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        child: Container(
                                          width: 152,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                  0.2,
                                                ),
                                                spreadRadius: 2,
                                                blurRadius: 2,
                                                offset: Offset(0, 0),
                                              ),
                                            ],
                                            // borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Text(
                                                //   service.company!.countryId
                                                //       .toString(),
                                                //   style: TextStyle(
                                                //     fontSize: 8,
                                                //     fontWeight: FontWeight.bold,
                                                //     color: Colors.black,
                                                //   ),
                                                // ),
                                                CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage: NetworkImage(
                                                    service.company!.companyLogo
                                                        .toString(),
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                // Text(
                                                //   service.serviceCategoryId
                                                //       .toString(),
                                                //   style: TextStyle(
                                                //     fontSize: 8,
                                                //     fontWeight: FontWeight.bold,
                                                //     color: Colors.black,
                                                //   ),
                                                // ),
                                                Text(
                                                  service.company!.companyName
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                //....................................Old...........................//

                                // Container(
                                //   height: 120,
                                //   width: screenWidth,
                                //   child: ListView.builder(
                                //     physics: BouncingScrollPhysics(),
                                //     scrollDirection: Axis.horizontal,
                                //     itemCount: category.services?.length ?? 0,
                                //     itemBuilder: (context, serviceIndex) {
                                //       final service =
                                //           category.services![serviceIndex];
                                //       return GestureDetector(
                                //         onTap: () {
                                //           bundleController.finalList.clear();
                                //           // print(service.companyId.toString());
                                //           box.write("validity_type", "");
                                //           box.write("company_id",
                                //               service.companyId.toString());
                                //           box.write("search_tag", "");
                                //           box.write(
                                //               "country_id",
                                //               service.company!.countryId
                                //                   .toString());

                                //           box.write("service_category_id",
                                //               category.id.toString());
                                //           bundleController.initialpage = 1;

                                //           Navigator.push(
                                //             context,
                                //             MaterialPageRoute(
                                //               builder: (context) =>
                                //                   SocialRechargeScreen(),
                                //             ),
                                //           );
                                //         },
                                //         child: Card(
                                //           color: Colors.white,
                                //           child: Container(
                                //             width: 152,
                                //             decoration: BoxDecoration(
                                //               color: Colors.white,
                                //               boxShadow: [
                                //                 BoxShadow(
                                //                   color: Colors.grey
                                //                       .withOpacity(0.2),
                                //                   spreadRadius: 2,
                                //                   blurRadius: 2,
                                //                   offset: Offset(0, 0),
                                //                 ),
                                //               ],
                                //               borderRadius:
                                //                   BorderRadius.circular(8),
                                //             ),
                                //             child: Center(
                                //               child: Column(
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment.center,
                                //                 children: [
                                //                   // Text(
                                //                   //   service.company!.countryId
                                //                   //       .toString(),
                                //                   //   style: TextStyle(
                                //                   //     fontSize: 8,
                                //                   //     fontWeight: FontWeight.bold,
                                //                   //     color: Colors.black,
                                //                   //   ),
                                //                   // ),
                                //                   CircleAvatar(
                                //                     radius: 30,
                                //                     backgroundImage: NetworkImage(
                                //                       service.company!.companyLogo
                                //                           .toString(),
                                //                     ),
                                //                   ),
                                //                   SizedBox(height: 8),
                                //                   // Text(
                                //                   //   service.serviceCategoryId
                                //                   //       .toString(),
                                //                   //   style: TextStyle(
                                //                   //     fontSize: 8,
                                //                   //     fontWeight: FontWeight.bold,
                                //                   //     color: Colors.black,
                                //                   //   ),
                                //                   // ),
                                //                   Text(
                                //                     service.company!.companyName
                                //                         .toString(),
                                //                     style: TextStyle(
                                //                       fontSize: 13,
                                //                       color: Colors.black,
                                //                       fontWeight: FontWeight.bold,
                                //                     ),
                                //                   ),
                                //                 ],
                                //               ),
                                //             ),
                                //           ),
                                //         ),
                                //       );
                                //     },
                                //   ),
                                // ),
                              ],
                            );
                          })
                          .toList(),
                    ],
                  )
                : Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}

import 'package:amutelecom/global_controller/languages_controller.dart';
import 'package:amutelecom/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:amutelecom/controllers/language_controller.dart';
import 'package:amutelecom/utils/colors.dart';
import 'package:amutelecom/widgets/animated_button.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import '../controllers/confirm_pin_controller.dart';

class NewConfirmpinScreen extends StatefulWidget {
  NewConfirmpinScreen({super.key});

  @override
  State<NewConfirmpinScreen> createState() => _NewConfirmpinScreenState();
}

class _NewConfirmpinScreenState extends State<NewConfirmpinScreen> {
  final ConfirmPinController confirmPinController = Get.put(
    ConfirmPinController(),
  );
  final languageController = Get.find<LanguagesController>();

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Step 2: Request focus when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Don't forget to dispose the FocusNode
    super.dispose();
  }

  Color borderColor = Colors.grey;
  void changeBorderColor() {
    setState(() {
      borderColor = Colors.green; // Change color to green
    });
  }

  bool isFinished = false;
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        confirmPinController.pinController.clear();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            height: screenHeight,
            width: screenWidth,
            child: Obx(
              () =>
                  confirmPinController.isLoading.value == false &&
                      confirmPinController.loadsuccess.value == false
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print(
                              confirmPinController.loadsuccess.value.toString(),
                            );
                          },
                          child: Lottie.asset('assets/loties/pin.json'),
                        ),
                        Container(
                          height: 50,
                          child: Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  confirmPinController.isLoading.value ==
                                              false &&
                                          confirmPinController
                                                  .loadsuccess
                                                  .value ==
                                              false
                                      ? languageController.tr(
                                          "CONFIRM_YOUR_PIN",
                                        )
                                      : languageController.tr("PLEASE_WAIT"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(width: 10),
                                confirmPinController.isLoading.value == true &&
                                        confirmPinController
                                                .loadsuccess
                                                .value ==
                                            true
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ),
                        // OTPInput(),
                        Container(
                          height: 40,
                          width: 100,
                          // color: Colors.red,
                          child: TextField(
                            focusNode: _focusNode,
                            style: TextStyle(fontWeight: FontWeight.w600),
                            controller: confirmPinController.pinController,
                            maxLength: 4,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              counterText: '',
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Expanded(
                        //   //DO your ui design
                        //   // I am keeping it blank for the demo
                        //   child: Container(),
                        // ),
                        // //Animated button
                        // AnimatedButton(
                        //   onclick: _onConfirmed,
                        // ),
                        // Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SwipeableButtonView(
                            buttonText: "Swipe to recharge",
                            buttonWidget: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(3.1416),
                              child: Container(
                                height: 50,
                                width: screenWidth,
                                child: Icon(Icons.arrow_forward_ios_rounded),
                              ),
                            ),
                            activeColor: AppColors.defaultColor,
                            isFinished: isFinished,
                            onWaitingProcess: () {
                              Future.delayed(Duration(seconds: 1), () {
                                setState(() {
                                  isFinished = true;
                                });
                              });
                            },
                            onFinish: () {
                              print("Finished");
                              setState(() {
                                isFinished = false;
                              });
                            },
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(
                            seconds: 2,
                          ), // Duration of the color change
                          curve: Curves.easeInOut, // Smooth curve
                          width: 150, // Width of the circle
                          height: 150, // Height of the circle
                          decoration: BoxDecoration(
                            color:
                                Colors.white, // Background color of the circle
                            shape: BoxShape.circle, // Make it a circle
                            border: Border.all(
                              color:
                                  borderColor, // Border color (initially grey)
                              width: 5, // Border width
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ), // Spacing between the circle and the button
                        ElevatedButton(
                          onPressed:
                              changeBorderColor, // When button is pressed, change the border color
                          child: Text('Change Border Color'),
                        ),
                        SizedBox(height: 100),
                      ],
                    )
                  : Center(
                      child: Container(
                        height: 250,
                        width: 250,
                        child: Lottie.asset('assets/loties/sand.json'),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _onConfirmed() {
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return Material(
    //         type: MaterialType.transparency,
    //         child: Center(
    //           child: Container(
    //             color: Colors.white,
    //             padding: EdgeInsets.symmetric(horizontal: 32, vertical: 72),
    //             margin: EdgeInsets.symmetric(horizontal: 32, vertical: 72),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 Icon(
    //                   Icons.check,
    //                   color: Colors.green,
    //                   size: 96,
    //                 ),
    //                 Center(
    //                   child: Text(
    //                     "Success",
    //                     style: TextStyle(
    //                       color: Colors.green,
    //                       fontSize: 24,
    //                     ),
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     });
    //Do your task whatever you want
    //As an example, Let's show a dummy dialog
    // await confirmPinController.verify();
    if (confirmPinController.loadsuccess.value == true) {
      // Get.toNamed(resultscreen);
    }
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return Material(
    //         type: MaterialType.transparency,
    //         child: Center(
    //           child: Container(
    //             color: Colors.white,
    //             padding: EdgeInsets.symmetric(horizontal: 32, vertical: 72),
    //             margin: EdgeInsets.symmetric(horizontal: 32, vertical: 72),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 Icon(
    //                   Icons.check,
    //                   color: Colors.green,
    //                   size: 96,
    //                 ),
    //                 Center(
    //                   child: Text(
    //                     "Success",
    //                     style: TextStyle(
    //                       color: Colors.green,
    //                       fontSize: 24,
    //                     ),
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     });
  }
}

class OTPInput extends StatefulWidget {
  @override
  _OTPInputState createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  // Define controllers and focus nodes for each OTP box
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  final ConfirmPinController confirmPinController = Get.put(
    ConfirmPinController(),
  );

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (_) => TextEditingController());
    _focusNodes = List.generate(4, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // Function to handle text change and move focus
  void _handleChange(String value, int index) {
    if (value.length == 1) {
      if (index < 3) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
      }
    }
    _updatePinController();
  }

  void _updatePinController() {
    String pin = _controllers.map((controller) => controller.text).join();

    confirmPinController.pinController.text = pin;
  }

  // Function to reset all input fields
  void _resetFields() {
    confirmPinController.pinController.clear();
    for (var controller in _controllers) {
      controller.clear();
    }
    FocusScope.of(context).requestFocus(_focusNodes[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              return SizedBox(
                width: 50,
                child: TextFormField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _handleChange(value, index),
                ),
              );
            }),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: _resetFields,
            child: Icon(FontAwesomeIcons.rotateRight),
          ),
        ],
      ),
    );
  }
}

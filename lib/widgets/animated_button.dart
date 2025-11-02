///Flutter Folks
///Created by: Md. Abdur Rouf
///Created at: Sep 4, 2021

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amutelecom/controllers/confirm_pin_controller.dart';
import 'dart:math' as m;

import 'package:amutelecom/utils/colors.dart';

class AnimatedButton extends StatefulWidget {
  final VoidCallback? onclick;
  const AnimatedButton({Key? key, this.onclick}) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  final ConfirmPinController confirmPinController = Get.put(
    ConfirmPinController(),
  );

  @override
  void initState() {
    super.initState();
    //Init the animation and it's event handler
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onclick?.call();
          controller.reset();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onLongPressStart(LongPressStartDetails details) {
    if (confirmPinController.pinController.text.isEmpty) {
      print("Empty pin");
      Get.snackbar(
        backgroundColor: Colors.red,
        colorText: Colors.white,
        "Error",
        "Enter pin first",
      );
      controller.reset();
    } else {
      print(" pin");
      controller.forward();
    }

    // controller.reset();
    // controller.forward();
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.4,
      child: ClipRRect(
        child: GestureDetector(
          onTap: () {
            final dummyDetails = LongPressStartDetails(
              globalPosition: Offset.zero,
              localPosition: Offset.zero,
            );
            // Access the onclick callback on a single tap
            // widget.onclick?.call();
            // _onLongPressStart(dummyDetails);
          },
          onLongPressStart: _onLongPressStart,
          onLongPressEnd: _onLongPressEnd,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, snapshot) {
              return CustomPaint(
                painter: ArcShapePainter(
                  progress: animation.value,
                  radius: MediaQuery.of(context).size.width,
                  color: AppColors.defaultColor,
                  strokeWidth: 6,
                ),
                //Logo and text
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //Logo
                    Image.asset("assets/icons/logo.png", height: 72, width: 72),
                    //Text
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Tap  to confirm",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

//Arc shape painter
class ArcShapePainter extends CustomPainter {
  //Define constructor parameters
  late double progress;
  late double radius;
  late Color color;
  late double strokeWidth;

  //Define private variables
  late Paint _linePaint;
  late Paint _solidPaint;
  late Path _path;

  //Create constructor and initialize private variables
  ArcShapePainter({
    required this.color,
    this.progress = .5,
    this.radius = 400,
    this.strokeWidth = 4,
  }) {
    _linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    _solidPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //First define the cord length and bound the angle
    var cordLength = size.width + 4;
    if (radius <= (cordLength * .5) + 16) radius = (cordLength * .5) + 16;
    if (radius >= 600) radius = 600;

    //Define required angles
    var arcAngle = m.asin((cordLength * .5) / radius) * 2;
    var startAngle = (m.pi + m.pi * .5) - (arcAngle * .5);
    var progressAngle = arcAngle * progress;

    //Define center of the available screen
    Offset center = Offset((cordLength * .5) - 2, radius + 8);

    //Draw the line arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      progressAngle,
      false,
      _linePaint,
    );

    //Draw the solid arc path
    _path = Path();
    _path.arcTo(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      arcAngle,
      true,
    );
    _path.lineTo(size.width, size.height);
    _path.lineTo(0, size.height);
    _path.close();

    //Draw some shadow over the solid arc
    canvas.drawShadow(_path.shift(Offset(0, 1)), color.withAlpha(100), 3, true);

    //Draw the solid arc using path
    canvas.drawPath(_path.shift(Offset(0, 12)), _solidPaint);
  }

  @override
  bool hitTest(Offset position) {
    //Accept long pressing only for the solid arc
    return _path.contains(position);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Make it conditionally return for release build
    // For now I am making always true
    return true;
  }
}

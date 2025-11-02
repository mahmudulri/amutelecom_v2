import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amutelecom/routes/routes.dart';
import 'package:amutelecom/utils/colors.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(signinscreen);
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.defaultColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Expanded(
                child: PageView.builder(
                  physics: BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemCount: demo_data.length,
                  controller: _pageController,
                  itemBuilder: (context, index) => WelcomeComponent(
                    title: demo_data[index].title,
                    longtext:
                        "Lorem ipsum dolor sit amet consectetur. In ornare ultrices cursus in integer mattis diam. Ullamcorper at vel. ",
                    imagelink: demo_data[index].imagelink,
                  ),
                ),
              ),
              Row(
                children: [
                  ...List.generate(
                    demo_data.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Dotindicator(isActive: index == _pageIndex),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_pageIndex < demo_data.length - 1) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                          print("Not End............");
                        } else {
                          print("End............");
                          Get.toNamed(signinscreen);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: AppColors.defaultColor,
                      ),
                      child: Icon(Icons.arrow_forward),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Dotindicator extends StatelessWidget {
  Dotindicator({super.key, this.isActive = false});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isActive ? 12 : 4,
      width: 6,
      decoration: BoxDecoration(
        color: AppColors.defaultColor,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

class Welcome {
  final String imagelink, title, longtext;

  Welcome(this.imagelink, this.title, this.longtext);
}

final List<Welcome> demo_data = [
  Welcome(
    "assets/images/slide-1.png",
    "Welcome to Pamir Net 1",
    "Lorem ipsum dolor sit amet consectetur. In ornare ultrices cursus in integer mattis diam. Ullamcorper at vel. ",
  ),
  Welcome(
    "assets/images/slide-2.png",
    "Welcome to Pamir Net 2",
    "Lorem ipsum dolor sit amet consectetur. In ornare ultrices cursus in integer mattis diam. Ullamcorper at vel. ",
  ),
  Welcome(
    "assets/images/slide-3.png",
    "Welcome to Pamir Net 3",
    "Lorem ipsum dolor sit amet consectetur. In ornare ultrices cursus in integer mattis diam. Ullamcorper at vel. ",
  ),
];

class WelcomeComponent extends StatelessWidget {
  const WelcomeComponent({
    super.key,
    required this.imagelink,
    required this.title,
    required this.longtext,
  });

  final String? imagelink;
  final String? title;
  final String? longtext;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(imagelink.toString(), height: 250),
        Spacer(),
        Text(
          "Welcome to Pamir Net",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 16),
        Text(
          longtext.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
        Spacer(),
      ],
    );
  }
}

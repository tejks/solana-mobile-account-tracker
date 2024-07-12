import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:solana_mobile_account_tracker/screens/onbording/add_account_screen.dart';
import 'package:solana_mobile_account_tracker/screens/onbording/welcome_screen.dart';
import 'package:solana_mobile_account_tracker/screens/splash_screen.dart';

class OnboardingItems {
  List items = [
    const WelcomeScreen(),
    const AddAccountScreen(),
  ];
}

class Onbording extends StatefulWidget {
  const Onbording({super.key});

  @override
  State<Onbording> createState() => _OnbordingState();
}

class _OnbordingState extends State<Onbording> {
  final controller = OnboardingItems();
  final _pageController = PageController();
  int currentPage = 0;

  get onPressed => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 221, 221),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: controller.items.length,
                  itemBuilder: (context, index) {
                    return controller.items[index];
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                currentPage -= 1;
                              });
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            },
                            child: Text(
                              'BACK',
                              style: TextStyle(
                                color: currentPage == 0
                                    ? const Color.fromARGB(0, 84, 77, 88)
                                    : const Color.fromARGB(255, 84, 77, 88),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SmoothPageIndicator(
                            controller: _pageController,
                            count: controller.items.length,
                            effect: const ExpandingDotsEffect(
                              dotColor: Color.fromARGB(255, 78, 81, 83),
                              activeDotColor: Color.fromARGB(255, 112, 37, 161),
                              dotHeight: 7,
                              dotWidth: 7,
                              spacing: 8,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                currentPage += 1;
                              });
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            },
                            child: Text(
                              'NEXT',
                              style: TextStyle(
                                color: currentPage > 0
                                    ? const Color.fromARGB(0, 109, 73, 133)
                                    : const Color.fromARGB(255, 109, 73, 133),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

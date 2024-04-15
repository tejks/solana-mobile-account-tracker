import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:solana_mobile_account_tracker/screens/onbording/add_account_screen.dart';
import 'package:solana_mobile_account_tracker/screens/onbording/welcome_screen.dart';

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
  final pageController = PageController();

  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      bottomSheet: Container(
        color: Colors.green[50],
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Skip Button
            TextButton(
                onPressed: () =>
                    pageController.jumpToPage(controller.items.length - 1),
                child: const Text("Skip")),

            //Indicator
            SmoothPageIndicator(
              controller: pageController,
              count: controller.items.length,
              onDotClicked: (index) => pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut),
              effect: const WormEffect(
                dotHeight: 12,
                dotWidth: 12,
                activeDotColor: Color.fromARGB(255, 206, 63, 63),
              ),
            ),

            //Next Button
            TextButton(
              onPressed: () => pageController.nextPage(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeIn,
              ),
              child: const Text("Next"),
            ),
          ],
        ),
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: controller.items.length,
        itemBuilder: (context, index) {
          return controller.items[index];
        },
        onPageChanged: (index) {
          setState(() {
            isLastPage = index == controller.items.length - 1;
          });
        },
      ),
    );
  }
}

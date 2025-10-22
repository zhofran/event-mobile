// ignore_for_file: unused_element

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class OnBoarding1Page extends StatefulWidget {
  const OnBoarding1Page({super.key});

  @override
  State<OnBoarding1Page> createState() => _OnBoarding1PageState();
}

class _OnBoarding1PageState extends State<OnBoarding1Page> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  int currentStep = 1;
  int totalSteps = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> slides = [
    {
      'title1': 'Your Journey',
      'title2': 'Starts Here',
      'description': 'Discover and manage events built for\nprofessionals.',
      'image': Assets.images.onboarding1.image(
        width: 250,
        height: 250,
        package: 'design',
      ),
    },
    {
      'title1': 'Discover Events',
      'title2': 'That Move You',
      'description': 'Find events you love, book tickets, and connect with others.',
      'image': Assets.images.onboarding2.image(
        width: 250,
        height: 250,
        package: 'design',
      ),
    },
    {
      'title1': 'Take the Stage,',
      'title2': 'Share Your Story',
      'description': 'Showcase your expertise and get matched with new opportunities.',
      'image': Assets.images.onboarding3.image(
        width: 250,
        height: 250,
        package: 'design',
      ),
    },
    {
      'title1': 'Make Every',
      'title2': 'Partnership Count',
      'description': 'Boost your brand through event sponsorships and live insights.',
      'image': Assets.images.onboarding4.image(
        width: 250,
        height: 250,
        package: 'design',
      ),
    },
    {
      'title1': 'Build Events That',
      'title2': 'Leave a Mark',
      'description': 'Plan, host, and analyze your events, all in one platform.',
      'image': Assets.images.onboarding5.image(
        width: 250,
        height: 250,
        package: 'design',
      ),
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.background,
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
              child: AnimatedStepProgressIndicator(
                currentStep: currentStep, 
                totalSteps: totalSteps,
                showLabel: false,
              )
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (int page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Content
                        _buildTopContent(index),

                        PaddingGap.xl(),

                        // Image
                        Center(child: slides[index]['image']),
                      ],
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: () async {
                  if (currentPage < slides.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                    setState(() {
                      currentStep += 1;
                    });
                  } else {
                    // Mark onboarding as seen
                    final prefs = await SharedPreferences.getInstance(); // { changed code }
                    await prefs.setBool('seenOnboarding', true); // { changed code }
                    $.navigator.replace(RegisterRoute(onResult: (bool _) {}));
                  }
                },
                size: FabButtonSize.large,
                width: double.infinity,
                child: Text(
                  currentPage == slides.length - 1 ? 'Continue' : 'Next',
                  style: FabTypography.body.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ),
            ),
          ],
        ) 
      ),
    );
  }

  Widget _buildTopContent(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          slides[index]['title1'],
          style: FabTypography.displayRegular40, 
        ),
        Text(
          slides[index]['title2'],
          style: FabTypography.displayRegular40, 
        ),
        PaddingGap.sm(),
        Text(
          slides[index]['description'],
          style: FabTypography.displayRegular16,
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }


}
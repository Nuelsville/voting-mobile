import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widgets/custom_button.dart';
import 'sign_in_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int currentIndex = 0;

  final List<Widget> onboardingPages = [
    const OnboardingPage(
      imagePath: 'assets/images/onboarding1.png',
      title: 'Welcome to Voting App',
      description: 'Cast your vote easily and securely.',
    ),
    const OnboardingPage(
      imagePath: 'assets/images/onboarding2.png',
      title: 'Secure and Reliable',
      description: 'Your vote is anonymous and protected.',
    ),
    const OnboardingPage(
      imagePath: 'assets/images/onboarding3.png',
      title: 'Get Started Now',
      description: 'Let your voice be heard today!',
    ),
  ];

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _navigateToSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentIndex == onboardingPages.length - 1;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: onboardingPages,
          ),
          Positioned(
            bottom: 140,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: onboardingPages.length,
              effect: WormEffect(
                dotColor: Colors.grey,
                activeDotColor: Theme.of(context).primaryColor,
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 16,
            right: 16,
            child: CustomButton(
              text: isLastPage ? 'Sign In' : 'Next',
              onPressed: () {
                print('Current Index: $currentIndex');
                if (isLastPage) {
                  _navigateToSignIn();
                } else {
                  print('Next');
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingPage({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    // Adjust heights based on screen size for responsiveness

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Vertical rectangle with an image
          Container(
            height: screenHeight * 0.35,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Centered title
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          // Body of text
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
        ],
      ),
    );
  }
}

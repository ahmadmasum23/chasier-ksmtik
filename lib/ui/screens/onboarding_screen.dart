import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir_kosmetic/ui/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kasir_kosmetic/ui/constants/images.dart';
import 'package:kasir_kosmetic/ui/screens/signup_screen.dart';


class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            subTitle,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.softPink,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30), 
          Image.asset(
            image,
            height: MediaQuery.of(context).size.height * 0.7, 
            width: MediaQuery.of(context).size.width * 0.7,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}


class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: AppImages.onboarding1,
                title: 'Kosmetik Terbaru Setiap Hari',
                subTitle: 'Berbagai jenis make up, tren rambut dan kecantikan setiap hari.',
              ),
              OnBoardingPage(
                image: AppImages.onboarding2,
                title: 'Kosmetik Terbaru',
                subTitle: 'Berbagai jenis make up, tren rambut dan kecantikan setiap hari.',
              ),
              OnBoardingPage(
                image: AppImages.onboarding3,
                title: 'Kosmetik Terbaru',
                subTitle: 'Berbagai jenis make up, tren rambut dan kecantikan setiap hari.',
              ),
            ],
          ),
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  void updatePageIndicator(index) => currentPageIndex.value = index;

  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  void nextPage() {
    if (currentPageIndex.value == 2) {
      Get.offAll(() => SignUpScreen());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;
    return Obx(
      () => Positioned(
        left: (MediaQuery.of(context).size.width - 56) / 2,
        bottom: MediaQuery.of(context).padding.bottom + 90,
        child: ElevatedButton(
          onPressed: () => controller.nextPage(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.softPink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 2),
          ),
          child: controller.currentPageIndex.value == 3
              ? const Text(
                  'Go',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : const Icon(
                  Iconsax.arrow_right_3,
                  color: Colors.black,
                  size: 28,
                ),
        ),
      ),
    );
  }
}
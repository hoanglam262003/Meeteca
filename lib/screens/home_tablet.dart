import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:math';

import '../controllers/brand_controller.dart';
import '../controllers/category_controller.dart';
import '../controllers/user_controller.dart';

bool hasScannedFace = false;
class HomeTablet extends StatefulWidget {
  @override
  State<HomeTablet> createState() => _HomeTabletState();
}
String generateOrderNumber() {
  final Random random = Random();
  String orderNumber = '';
  for (int i = 0; i < 12; i++) {
    orderNumber += random.nextInt(10).toString();
  }
  return orderNumber;
}
class _HomeTabletState extends State<HomeTablet> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  final List<String> _photos = [
    'assets/images/food_menu_1.png',
    'assets/images/food_menu_2.png',
    'assets/images/food_menu_3.png',
  ];

  @override
  void initState() {
    super.initState();
    final userController = Get.find<UserController>();
    final categoryController = Get.find<CategoryController>();
    final brandController = Get.find<BrandController>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await userController.fetchBrandIdByUserId();
      await categoryController.fetchCategoriesByBrandId(brandController.brand.value.brandId);
    });
    // Start the timer to change photos every 3 seconds
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _photos.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      // Animate the page change with a left-to-right slide
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 800), // Increase duration for a more dramatic transition
        curve: Curves.easeInOutCubic, // Use a smoother curve for a more cinematic effect
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    hasScannedFace = false;
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xffB5441C),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 2),
            Container(
              height: size.height * 0.75,
              width: size.width * 0.35,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _photos.length,
                itemBuilder: (context, index) {
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 500), // Fade duration
                    child: Image.asset(
                      _photos[index],
                      key: ValueKey<String>(_photos[index]),
                      fit: BoxFit.fill,
                    ),
                  );
                },
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                    textStyle: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () {
                    String orderNumber = generateOrderNumber(); // Tạo mã đơn hàng
                    hasScannedFace = false;
                    Get.toNamed('/aimenu', arguments: orderNumber);
                  },
                  child: Text(
                    'Start Ordering',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
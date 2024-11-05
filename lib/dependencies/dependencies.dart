import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:golheal_app/controllers/brand_controller.dart';
import 'package:golheal_app/controllers/category_controller.dart';
import 'package:golheal_app/controllers/payment_controller.dart';
import 'package:golheal_app/controllers/product_controller.dart';
import 'package:golheal_app/data/repository/brand_repository.dart';
import 'package:golheal_app/data/repository/category_repository.dart';
import 'package:golheal_app/data/repository/payment_repository.dart';
import 'package:golheal_app/data/repository/product_repository.dart';
import 'package:golheal_app/data/repository/user_repository.dart';
import 'package:golheal_app/providers/user_provider.dart';
import 'package:golheal_app/utils/app_constants.dart';

import '../controllers/user_controller.dart';
import '../data/api/api_client.dart';

class GetXDependencies {
  static Future<void> init() async {
    Get.lazyPut(() => UserProvider());
    Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BaseUrl), fenix: true);
    Get.lazyPut(() => UserController(userPro: Get.put(UserProvider()), userRe: Get.find()), fenix: true);
    Get.lazyPut(() => UserRepository(apiClient: Get.find()));
    Get.lazyPut(() => PaymentController(paymentRepository: Get.find()), fenix: true);
    Get.lazyPut(() => PaymentRepository(apiClient: Get.find()));
    Get.lazyPut(() => BrandController(brandRepository: Get.find()), fenix: true);
    Get.lazyPut(() => BrandRepository(apiClient: Get.find()));
    Get.lazyPut(() => CategoryController(categoryRepository: Get.find()), fenix: true);
    Get.lazyPut(() => CategoryRepository(apiClient: Get.find()));
    Get.lazyPut(() => ProductController(productRepository: Get.find()), fenix: true);
    Get.lazyPut(() => ProductRepository(apiClient: Get.find()));
  }
}

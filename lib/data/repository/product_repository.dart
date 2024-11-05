import 'package:get/get.dart';
import 'package:golheal_app/data/api/api_client.dart';
import 'package:golheal_app/utils/app_constants.dart';

class ProductRepository extends GetxService {
  final ApiClient apiClient;
  ProductRepository({required this.apiClient});

  Future<Response> getProductsByCategoryName(String categoryName, int brandId) async {
    return await apiClient.getData('${AppConstants.GET_PROD_BY_CATE}?categoryName=$categoryName&brandId=$brandId');
  }
}
import 'package:get/get.dart';
import 'package:golheal_app/data/api/api_client.dart';
import 'package:golheal_app/utils/app_constants.dart';

class BrandRepository extends GetxService{
  final ApiClient apiClient;
  BrandRepository({required this.apiClient});
  Future<Response> getBrandByUserId(int? userId) async {
    print(userId);
     return await apiClient.getData('${AppConstants.GET_BRAND}?user-id=$userId');
  }
}
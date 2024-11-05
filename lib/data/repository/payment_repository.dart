import 'package:get/get.dart';
import 'package:golheal_app/data/api/api_client.dart';
import 'package:golheal_app/models/order_model.dart';
import 'package:golheal_app/utils/app_constants.dart';

class PaymentRepository extends GetxService{
  final ApiClient apiClient;
  PaymentRepository({required this.apiClient});

  Future<Response> createQrPayment(String url) async {
    return await apiClient.getData(url, skipTokenCheck: true);
  }

  Future<Response> createOrder(Order order) async {
    return await apiClient.postData(AppConstants.ADD_ORDER, order.toJson());
  }
}

import 'package:get/get.dart';
import 'package:golheal_app/data/api/api_client.dart';
import '../../utils/app_constants.dart';

class UserRepository extends GetxService {
  ApiClient apiClient;
  UserRepository({required this.apiClient});

  Future<Response> login(Map<String, dynamic> data) async {
    print(data.toString());
    return await apiClient.postData('${AppConstants.POST_LOGIN}', data,
        skipTokenCheck: true);
  }

}
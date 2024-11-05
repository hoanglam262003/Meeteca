import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:golheal_app/controllers/brand_controller.dart';
import '../data/api/api_client.dart';
import '../data/repository/user_repository.dart';
import '../models/login_model.dart';
import '../providers/user_provider.dart';

class UserController extends GetxController {
  UserProvider userPro;
  UserRepository userRe;

  UserController({required this.userPro, required this.userRe});

  final box = GetStorage();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void onInit() {
    // getUserByID(box.read('user_id'));
  }

  Future<bool> login({required LoginModel data}) async {
    _isLoading = true;
    update();
    print(data.toJson());

    try {
      Response re = await userRe.login(data.toJson());
      print(re.statusText);

      if (re.statusCode == 200 && re.body['data'] != null) {
        var responseData = re.body['data'];
        var tokenData = responseData['token'];

        ///Lưu vào bộ nhớ cache
        int? id = responseData['user-id'];
        String? token = tokenData['access-token'];
        int? role = responseData['role-id'];
        DateTime expiryDate = DateTime.now().add(Duration(days: 1));
        /// set dữ liệu cho phiên làm việc hiện tại
        userPro.setToken(token, expiryDate, role, id);
        Get.find<ApiClient>().updateToken(token! ?? '');
        Get.offAllNamed('/homepage');
        return true;  // Đăng nhập thành công
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.TOP, margin: EdgeInsets.all(12));
    }

    _isLoading = false;
    update();
    return false;  // Đăng nhập thất bại
  }

  Future<void> fetchBrandIdByUserId() async {
    int? userId = userPro.id;  // Truy cập trực tiếp vào thuộc tính id
    if (userId != null) {
      await Get.find<BrandController>().fetchBrandByUserId(userId);
    }
  }
}
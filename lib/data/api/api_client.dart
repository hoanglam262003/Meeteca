import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:golheal_app/utils/show_custom_top_snackbar.dart';
import 'dart:convert';

class ApiClient extends GetConnect implements GetxService {
  late String token;
  final String appBaseUrl;
  late Map<String, String > _mainHeaders;
  final box = GetStorage();

  ApiClient({required this.appBaseUrl}) {
    baseUrl = appBaseUrl;
    timeout = const Duration(seconds: 30);
    token =box.read('token') ?? '';
    _mainHeaders= {
      'Content-type' : ' application/json',
      if (token.isNotEmpty) 'Authorization' : 'Bearer $token'
    };
  }
  void onInit(){
    super.onInit();
  }

  void updateToken(String newToken) {
    token = newToken;
    _mainHeaders['Authorization'] = 'Bearer $token';
    box.write('token', token);
    print(_mainHeaders['Authorization']);
  }
  bool isTokenExpired() {
    String? expiryString = box.read('token_expiry');
    print(expiryString);
    if (expiryString == null) return true;
    DateTime expiryDate = DateTime.parse(expiryString);
    return DateTime.now().isAfter(expiryDate);
  }
/// lấy data
  Future<Response> getData(String uri, {bool skipTokenCheck = false}) async{
    print('TokenExpired: ${isTokenExpired()}');
    print('SkipTokenCheck: ${skipTokenCheck}');
    if (!skipTokenCheck && isTokenExpired()) {
      showCustomTopSnackbar(title: 'Session expired', content: 'Please log in again.');
      box.write('token', '');
      Get.offAllNamed('/');
      return Response(statusCode: 403, bodyString: 'Token expired');
    }
    try{
      final fullUrl = '$baseUrl$uri';
      print('Start GET URL: $fullUrl');
      print('Headers: $_mainHeaders');
      Response res = await get(uri,headers: _mainHeaders);
      print("Connected to DB");
      return res;
    }
    catch(e){
      return  Response(statusCode: 1, statusText: e.toString());
    }
  }
/// tạo data
  Future<Response> postData(String uri, dynamic data, {bool skipTokenCheck = false, bool isFormEncoded = false}) async {
    if (!skipTokenCheck && isTokenExpired()) {
      Get.snackbar('Session expired', 'Please log in again.', snackPosition: SnackPosition.BOTTOM, margin: EdgeInsets.all(12));
      return Response(statusCode: 403, bodyString: 'Token expired');
    }

    try {
      final fullUrl = '$baseUrl$uri';
      print('Start POST URL: $fullUrl');
      print('Headers: $_mainHeaders');

      // Kiểm tra nếu cần gửi dữ liệu với định dạng form-encoded
      Response res;
      if (isFormEncoded) {
        // Chuyển đổi dữ liệu thành chuỗi form-encoded
        final formData = data.map((key, value) => MapEntry(key, value.toString()));
        res = await post(uri, formData.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&'), headers: _mainHeaders);
      } else {
        res = await post(uri, jsonEncode(data), headers: _mainHeaders); // Giữ nguyên việc gửi dữ liệu JSON
      }

      print("Send post request success");
      print(res.statusCode);
      return res;
    } catch (e) {
      return Response(statusCode: 500, statusText: e.toString());
    }
  }
/// put data
  Future<Response> putData(String uri, data, {bool skipTokenCheck = false}) async {
    if (!skipTokenCheck && isTokenExpired()) {
      Get.snackbar('Session expired', 'Please log in again.',snackPosition: SnackPosition.BOTTOM,margin: EdgeInsets.all(12));
      return Response(statusCode: 403, bodyString: 'Token expired');
    }
    try {
      final fullUrl = '$baseUrl$uri';
      print('Start PUT URL: $fullUrl');
      print('Headers: $_mainHeaders');
      Response res = await put(uri, data, headers: _mainHeaders);
      print("Send request success");
      return res;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

}
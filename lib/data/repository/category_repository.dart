import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:golheal_app/data/api/api_client.dart';
import 'package:golheal_app/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class CategoryRepository extends GetxService {
  final ApiClient apiClient;
  CategoryRepository({required this.apiClient});

  Future<Response> getCategoriesByBrandId(int? brandId) async {
    return await apiClient
        .getData('${AppConstants.GET_CATEGORY}?brand-id=$brandId');
  }
  Future<Response> getCategoriesByImageAndBrandId(File image, int? brandId, String contentType) async {
    var uri = Uri.parse('${AppConstants.BaseUrl}${AppConstants.RECOMMEND_MENU}');
    var request = http.MultipartRequest('POST', uri);

    // Attach brandId
    request.fields['brand-id'] = brandId.toString();

    // Attach image with the correct content type
    var imageFile = await http.MultipartFile.fromPath(
      'faceImage',
      image.path,
      contentType: MediaType.parse(contentType), // Sử dụng contentType được truyền vào
    );
    request.files.add(imageFile);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    // Kiểm tra mã phản hồi và phân tích body JSON trước khi trả về
    if (response.statusCode == 200) {
      // Phân tích cú pháp JSON từ body string
      var parsedBody = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      return Response(
        statusCode: response.statusCode,
        body: parsedBody,
        statusText: response.reasonPhrase,
      );
    } else {
      print("Error: ${response.statusCode}, body: ${response.body}");
      return Response(
        statusCode: response.statusCode,
        body: response.body,
        statusText: response.reasonPhrase,
      );
    }
  }
}

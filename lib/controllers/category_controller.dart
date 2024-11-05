import 'dart:io';

import 'package:get/get.dart';
import 'package:golheal_app/data/repository/category_repository.dart';
import 'package:golheal_app/models/category_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class CategoryController extends GetxController {
  final CategoryRepository categoryRepository;
  CategoryController({required this.categoryRepository});

  var categories = <CategoryModel>[].obs;

  Future<void> fetchCategoriesByBrandId(int? brandId) async {
    var fetchedCategories = await categoryRepository.getCategoriesByBrandId(brandId);
    if (fetchedCategories.statusCode == 200 && fetchedCategories.body != null) {
      final List<dynamic> response = fetchedCategories.body['data'];
      categories.value = response.map((x) => CategoryModel.fromJson(x)).toList();
    } else {
      print("Failed to fetch categories by brandId ${fetchedCategories.statusCode}");
    }
  }

  Future<void> fetchCategoriesByImageAndBrandId(File imageFile, int? brandId) async {
    // Xác định loại ảnh dựa trên phần mở rộng
    final String extension = basename(imageFile.path).split('.').last.toLowerCase();
    String contentType;

    if (extension == 'jpg' || extension == 'jpeg') {
      contentType = 'image/jpeg';
    } else if (extension == 'png') {
      contentType = 'image/png';
    } else {
      print('Unsupported image format: $extension');
      return; // Nếu định dạng không hợp lệ, thoát khỏi hàm
    }

    // Gửi ảnh và brandId tới backend
    var fetchedCategories = await categoryRepository.getCategoriesByImageAndBrandId(imageFile, brandId, contentType);

    if (fetchedCategories.statusCode == 200 && fetchedCategories.body != null) {
      final List<dynamic> response = fetchedCategories.body['data'];
      categories.value = response.map((x) => CategoryModel.fromJson(x)).toList();
    } else {
      print("Failed to fetch categories by image and brandId: ${fetchedCategories.statusCode}");
    }
  }

}

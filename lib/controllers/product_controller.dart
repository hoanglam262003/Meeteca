import 'package:get/get.dart';
import 'package:golheal_app/data/repository/product_repository.dart';
import 'package:golheal_app/models/product_model.dart';

class ProductController extends GetxController {
  final ProductRepository productRepository;
  ProductController({required this.productRepository});

  var productList = <ProductModel>[].obs;

  Future<void> fetchProductsByCategoryName(String categoryName, int brandId) async {
    var fetchedProducts = await productRepository.getProductsByCategoryName(categoryName, brandId);
    print(fetchedProducts.statusCode);

    if (fetchedProducts.body != null && fetchedProducts.statusCode == 200) {
      print(fetchedProducts.body.toString());
      List<dynamic> jsonList = fetchedProducts.body['data'];

      productList.value = jsonList.map((json) => ProductModel.fromJson(json)).toList();
      print(productList.toString());

    } else {
      print("Failed to fetch products by categoryName");
    }
  }
}
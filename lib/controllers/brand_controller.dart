import 'package:get/get.dart';
import 'package:golheal_app/data/repository/brand_repository.dart';
import 'package:golheal_app/models/brand_model.dart';

class BrandController extends GetxController {
  final BrandRepository brandRepository;
  BrandController({required this.brandRepository});

  var brand = BrandModel().obs;

  Future<void> fetchBrandByUserId(int? userId) async {
    var fetchedBrand = await brandRepository.getBrandByUserId(userId);
    print(fetchedBrand.statusCode);
    if (fetchedBrand.body != null && fetchedBrand.statusCode == 200) {
      print(fetchedBrand.body.toString());
      var json = fetchedBrand.body['data'];
      print(json.toString());

      brand.value = BrandModel.fromJson(json);
      print(brand.toString());

    } else {
      print("Failed to fetch brand by userId");
    }
  }
}
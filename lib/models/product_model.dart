class ProductModel {
  final int productId;
  final String productCode;
  final String createDate;
  final String productName;
  final String? spotlightVideoImageUrl;
  final String? spotlightVideoImageName;
  final String? imageUrl;
  final String? imageName;
  final String description;
  final int categoryId;
  final int brandId;
  final double price;
  final String categoryName;
  final String? segment;
  final int? discount;

  ProductModel({
    required this.productId,
    required this.productCode,
    required this.createDate,
    required this.productName,
    this.spotlightVideoImageUrl,
    this.spotlightVideoImageName,
    this.imageUrl,
    this.imageName,
    required this.description,
    required this.categoryId,
    required this.brandId,
    required this.price,
    required this.categoryName,
    this.segment,
    this.discount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product-id'],
      productCode: json['product-code'],
      createDate: json['create-date'],
      productName: json['product-name'],
      spotlightVideoImageUrl: json['spotlight-video-image-url'],
      spotlightVideoImageName: json['spotlight-video-image-name'],
      imageUrl: json['image-url'],
      imageName: json['image-name'],
      description: json['description'],
      categoryId: json['category-id'],
      brandId: json['brand-id'],
      price: json['price'],
      categoryName: json['category-name'],
      segment: json['segment'],
      discount: json['discount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product-id': productId,
      'product-code': productCode,
      'create-date': createDate,
      'product-name': productName,
      'spotlight-video-image-url': spotlightVideoImageUrl,
      'spotlight-video-image-name': spotlightVideoImageName,
      'image-url': imageUrl,
      'image-name': imageName,
      'description': description,
      'category-id': categoryId,
      'brand-id': brandId,
      'price': price,
      'category-name': categoryName,
      'segment': segment,
      'discount': discount,
    };
  }
}

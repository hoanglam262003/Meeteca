class CategoryModel {
  int? categoryId;
  String? categoryCode;
  String? categoryName;

  CategoryModel({this.categoryId, this.categoryCode, this.categoryName});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['category-id'];
    categoryCode = json['category-code'];
    categoryName = json['category-name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category-id'] = this.categoryId;
    data['category-code'] = this.categoryCode;
    data['category-name'] = this.categoryName;
    return data;
  }
}
class BrandModel {
  int? brandId;
  String? brandCode;
  String? brandName;
  int? userId;
  String? createDate;
  int? status;
  String? imageUrl;
  String? imageName;
  String? storeName;

  BrandModel(
      {this.brandId,
        this.brandCode,
        this.brandName,
        this.userId,
        this.createDate,
        this.status,
        this.imageUrl,
        this.imageName,
        this.storeName});

  BrandModel.fromJson(Map<String, dynamic> json) {
    brandId = json['brand-id'];
    brandCode = json['brand-code'];
    brandName = json['brand-name'];
    userId = json['user-id'];
    createDate = json['create-date'];
    status = json['status'];
    imageUrl = json['image-url'];
    imageName = json['image-name'];
    storeName = json['store-name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brand-id'] = this.brandId;
    data['brand-code'] = this.brandCode;
    data['brand-name'] = this.brandName;
    data['user-id'] = this.userId;
    data['create-date'] = this.createDate;
    data['status'] = this.status;
    data['image-url'] = this.imageUrl;
    data['image-name'] = this.imageName;
    data['store-name'] = this.storeName;
    return data;
  }
}
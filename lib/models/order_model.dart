class Order {
  List<Products>? products;

  Order({this.products});

  Order.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String? productName;
  int? quantity;
  int? price;

  Products({this.productName, this.quantity, this.price});

  Products.fromJson(Map<String, dynamic> json) {
    productName = json['product-name'];
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product-name'] = this.productName;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    return data;
  }
}
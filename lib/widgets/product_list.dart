import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  final products = [
    {"name": "Mozarella Cheese", "price": "\$2.50", "rating": 4.6, "reviews": "(1.5k)", "image": "assets/images/food_menu_1.png"},
    {"name": "Honey Glazed Chicken", "price": "\$5.00", "rating": 4.5, "reviews": "(2k)", "image": "assets/images/food_menu_2.png"},
    {"name": "Pizza Hut", "price": "\$1.50", "rating": 4.5, "reviews": "(1k)", "image": "assets/images/food_menu_3.png"},
    {"name": "Beef Noodles", "price": "\$1.50", "rating": 4.8, "reviews": "(500)", "image": "assets/images/food_menu_3.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Giữ nguyên bố cục 2 cột
        mainAxisSpacing: 5, // Khoảng cách dọc giữa các hàng
        crossAxisSpacing: 5, // Khoảng cách ngang giữa các cột
        childAspectRatio: 4.5, // Tỷ lệ chiều rộng/chiều cao của mỗi item
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2, // Độ đổ bóng của mỗi item
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3), // Giảm bớt margin trên và dưới
          child: Padding(
            padding: const EdgeInsets.all(6.0), // Giảm padding bên trong
            child: Row(
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    products[index]['image'] as String,
                    width: 60, // Chỉnh kích thước ảnh nhỏ hơn
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 8),
                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        products[index]['name'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow, size: 14),
                          SizedBox(width: 3),
                          Text(
                            "${products[index]['rating']} ",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            products[index]['reviews'] as String,
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        products[index]['price'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Cart Icon
                Icon(Icons.shopping_cart, color: Colors.grey, size: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:golheal_app/controllers/brand_controller.dart';
import 'package:golheal_app/controllers/category_controller.dart';
import 'package:golheal_app/controllers/product_controller.dart';
import 'package:golheal_app/controllers/user_controller.dart';
import 'package:golheal_app/screens/camera_popup.dart';
import 'package:golheal_app/screens/home_tablet.dart';
import 'package:golheal_app/screens/payment_screen.dart';
import 'package:intl/intl.dart';
import 'dart:async'; // Thêm thư viện dart:async để sử dụng Timer
import 'package:provider/provider.dart';
import 'package:golheal_app/providers/order_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AIMenuScreen extends StatefulWidget {
  AIMenuScreen();
  @override
  _AIMenuScreenState createState() => _AIMenuScreenState();
}

class _AIMenuScreenState extends State<AIMenuScreen> {
  List<Map<String, dynamic>> displayedProducts = [];
  List<Map<String, dynamic>> orderItem = [];
  String formattedDateTime = "";
  Timer? timer;
  String? selectedItemName;
  String? selectedItemImagePath;
  String selectedItemDescription = "Điều đặc biệt ở món này chính là sự kết hợp của những nguyên liệu từ thiên nhiên, không chỉ ngon miệng mà còn mang lại những giá trị dinh dưỡng tuyệt vời. Mỗi thành phần đều chứa đựng trong đó là sức khỏe và sự tươi mới. Bạn có thể cảm nhận được sự chăm sóc của người đầu bếp qua từng lớp hương vị, từ cách chế biến tinh tế cho đến cách bày trí đẹp mắt. Món này không chỉ là một phần của bữa ăn mà còn là một trải nghiệm văn hóa, là sự giao thoa giữa truyền thống và hiện đại. Nó có thể được thưởng thức trong một buổi tiệc lớn hay chỉ đơn giản là một bữa ăn gia đình ấm cúng. Dù ở đâu, món này đều mang lại niềm vui và sự kết nối giữa mọi người. Hãy để món này dẫn dắt bạn vào một hành trình ẩm thực đầy màu sắc và hương vị. Bạn sẽ nhận ra rằng, không chỉ là sự ngon miệng, mà còn là cảm xúc, là những kỷ niệm gắn liền với những bữa ăn bên bạn bè và người thân. Khi bạn ăn, hãy để món này mở ra những câu chuyện thú vị, khiến bạn cảm thấy thật sự sống động trong từng khoảnh khắc. Thực sự, đó chính là món mà bạn sẽ không bao giờ quên!"; // Mô tả cố định
  double? selectedItemPrice;
  bool _isFaceScanned = false;

  void selectItem(String name, String imagePath, double price) {
    setState(() {
      selectedItemName = name;
      selectedItemImagePath = imagePath;
      selectedItemPrice = price;
    });
  }

  void clearSelectedItem() {
    setState(() {
      selectedItemName = null;
      selectedItemImagePath = null;
      selectedItemPrice = null;
    });
  }

  /// Hàm thêm món vào đơn hàng
  void addToOrder(String name, String imagePath, double price, String discount) {
    Provider.of<OrderProvider>(context, listen: false).addToOrder(name, imagePath, price, discount);
    print("Đã thêm vào đơn hàng: $name, Giá: $price");
  }

  /// Hàm cập nhật số lượng món trong đơn hàng
  void updateQuantity(int index, int delta) {
    Provider.of<OrderProvider>(context, listen: false).updateQuantity(index, delta);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeFaceScanCheck();
    });
    formattedDateTime = DateFormat("MMMM, d'th' yyyy, h:mm a").format(DateTime.now());
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        formattedDateTime = DateFormat("MMMM, d'th' yyyy, h:mm a").format(DateTime.now());
      });
    });
  }

  Future<void> initializeFaceScanCheck() async {
    final categoryController = Get.find<CategoryController>();
    final userController = Get.find<UserController>();
    final brandController = Get.find<BrandController>();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    hasScannedFace = prefs.getBool('hasScannedFace') ?? false;

    // Thực hiện quét mặt ngay khi khởi động nếu chưa quét
    if (!hasScannedFace) {
      await userController.fetchBrandIdByUserId();

      // Hiển thị popup quét mặt ngay lập tức
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CameraPopup(
            brandId: brandController.brand.value.brandId ?? 0,
            categoryController: categoryController,
          );
        },
      );

      // Gán cờ đã quét mặt
      await prefs.setBool('hasScannedFace', true);

      // Đảm bảo hình ảnh đã được quét mặt
      await categoryController.fetchCategoriesByImageAndBrandId(
          File('faceImage'), brandController.brand.value.brandId);

      // Cập nhật trạng thái quét mặt
      setState(() {
        _isFaceScanned = true;
      });
    } else {
      // Nếu đã quét mặt, chỉ cần cập nhật trạng thái
      setState(() {
        _isFaceScanned = true;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel(); // Hủy timer khi widget không còn hiển thị
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isFaceScanned) {
      // Hiển thị loading hoặc chờ quét mặt
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),  // Hiển thị khi đang chờ quét mặt
      );
    }
    late String orderNumber = '0';
    final argument = Get.arguments;
    if (argument is String) {
      orderNumber = argument;
    }

    final orderProvider = Provider.of<OrderProvider>(context);
    List<Map<String, dynamic>> orderItems = orderProvider.orderItems;
    // Tính tổng phụ (subtotal)
    double subtotal = orderItems.fold(0.0, (sum, item) {
      double price = item['price'];
      return sum + price * item['quantity'];
    });

    double totalDiscount = 0.0;
    for (var item in orderItems) {
      double price = item['price'];
      int quantity = item['quantity'];
      String discountString = item['discount'];
      double discount = (discountString != null && discountString.isNotEmpty)
          ? double.tryParse(discountString) != null
          ? double.parse(discountString) / 100
          : 0.0
          : 0.0; // Chuyển discount thành phần trăm
      totalDiscount += price * quantity * discount; // Tính tổng discount
    }

    double total = subtotal - totalDiscount;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Không hiển thị nút back
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('hasScannedFace', false);
                    orderProvider.clearOrder();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeTablet()),
                          (Route<dynamic> route) => false, // Xóa toàn bộ các route trước đó
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0), // Thêm padding 10px bên trái
                    child: Image.asset('assets/images/logo.png', height: 60),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            Expanded(
              flex: 2, // Điều chỉnh tỷ lệ chiếm không gian nếu cần
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search product or any order",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1, // Điều chỉnh tỷ lệ chiếm không gian nếu cần
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(formattedDateTime, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 100,
            color: Colors.white,
            child: Column(
              children: [
                _buildSidebarButton(Icons.recommend, "AI RECOMMEND", () {
                  setState(() {
                    clearSelectedItem(); // Để xóa món đã chọn khi trở về danh sách
                  });
                }),
                _buildSidebarButton(Icons.menu, "MENU", () {
                  Get.toNamed('/menu', arguments: orderNumber);
                }),
                _buildSidebarButton(Icons.payment, "PAYMENT", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(orderItems: orderItems), // Truyền orderItems vào PaymentScreen
                    ),
                  );
                }),
              ],
            ),
          ),
          // Nội dung chính
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Các nút danh mục
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(() {
                    var categoryController = Get.find<CategoryController>();
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                      child: Row(
                        children: categoryController.categories.map((category) {
                          return categoryController.categories.isNotEmpty
                              ? _buildCategoryButton(
                              category.categoryName ?? 'This category do not have any product!')
                              : Center(child: Text('Cannot load category!'));
                        }).toList(),
                      ),
                    );
                  }),
                ),
                // Thay thế phần hiển thị chi tiết món ăn trong hàm build
                if (selectedItemName != null) // Kiểm tra nếu có món đã chọn
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // Nút Close ở góc trên bên phải
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: clearSelectedItem,
                              ),
                            ),

                            // Tên món ăn
                            Text(
                              selectedItemName!,
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            // Hình ảnh món ăn
                            Image(
                              height: 200,
                              fit: BoxFit.cover,
                              image: selectedItemImagePath != null && selectedItemImagePath!.isNotEmpty
                                  ? NetworkImage(selectedItemImagePath!)
                                  : AssetImage('assets/images/logo.png') as ImageProvider,
                            ),
                            SizedBox(height: 10),
                            // Mô tả món ăn
                            Container(
                              height: 200.0, // Chiều cao giới hạn của phần mô tả
                              child: SingleChildScrollView(
                                child: Text(
                                  selectedItemDescription,
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            // Giá món ăn
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "₫${selectedItemPrice!.toStringAsFixed(0)}",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (selectedItemName == null)
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      padding: const EdgeInsets.all(16),
                      children: displayedProducts.isNotEmpty
                          ? displayedProducts.map((product) {
                        return _buildProductCard(
                            product['image-url'] ?? 'assets/images/logo.png',
                            product['product-name'],
                            product['price'],
                            product['discount'].toString()
                        );
                      }).toList()
                          : [Center(child: Text("No products available"))], // Thông báo khi không có sản phẩm
                    ),
                  ),

              ],
            ),
          ),
          // Thanh đơn hàng
          Container(
            width: 250,
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ORDER: ${orderNumber}", style: TextStyle(fontSize: 20)), // Hiển thị mã đơn hàng
                SizedBox(height: 15),
                Expanded(
                  child: orderItems.isNotEmpty
                      ? ListView.builder(
                    itemCount: orderItems.length,
                    itemBuilder: (context, index) {
                      return _buildOrderItem(
                        context,
                        orderItems[index]['name'],
                        orderItems[index]['imagePath'],
                        orderItems[index]['price'],
                        orderItems[index]['discount'],
                        orderItems[index]['quantity'],
                        index,
                      );
                    },
                  )
                      : Center(
                    child: Text("No items in the order"),
                  ),
                ),
                // Hiển thị subtotal, discount và total
                Text("SUBTOTAL: ₫${subtotal.toStringAsFixed(0)}", style: TextStyle(fontSize: 18)),
                Text("DISCOUNT: ₫${totalDiscount.toStringAsFixed(0)}", style: TextStyle(fontSize: 18)),
                Divider(),
                Text(
                  "TOTAL: ₫${total.toStringAsFixed(0)}",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                // Nút hủy và thanh toán
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        orderProvider.clearOrder();
                      },
                      child: Text("CANCEL"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(orderItems: orderItems), // Truyền orderItems vào PaymentScreen
                          ),
                        );
                      },
                      child: Text("PAYMENT"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Xây dựng nút sidebar
  Widget _buildSidebarButton(IconData icon, String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          GestureDetector(
            onTap: onPressed, // Gọi phương thức khi nhấn nút
            child: Icon(icon, size: 32, color: Colors.black),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String title) {
    return GestureDetector(
      onTap: () async {
        // Lấy ProductController
        final productController = Get.find<ProductController>();
        final brandController = Get.find<BrandController>();
        // Gọi hàm lấy danh sách sản phẩm theo CategoryName
        await productController.fetchProductsByCategoryName(title, brandController.brand.value.brandId!);

        // Cập nhật danh sách sản phẩm hiển thị
        setState(() {
          displayedProducts = productController.productList.map((product) {
            return {
              'image-url': product.imageUrl,
              'product-name': product.productName,
              'price': product.price,
              'discount': product.discount,
            };
          }).toList();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        margin: EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }


  /// Xây dựng thẻ sản phẩm
  Widget _buildProductCard(String imagePath, String name, double price, String discount) {
    return GestureDetector(
      onTap: () {
        selectItem(name, imagePath, price);
      },
      child: Card(
        child: Stack(
          children: [
            Column(
              children: [
                // Hình ảnh sản phẩm
                Expanded(
                  child: imagePath.startsWith('http')
                      ? Image.network(imagePath, fit: BoxFit.cover) // Sử dụng Image.network cho hình ảnh từ URL
                      : Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                ),
                // Thông tin sản phẩm
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("₫${price.toStringAsFixed(0)}", style: TextStyle(fontSize: 16)),
                          if (discount.isNotEmpty && discount != "null")
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                              color: Colors.red,
                              child: Text(discount + "%", style: TextStyle(color: Colors.white)),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Nút "Add to Order"
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      addToOrder(name, imagePath, price, discount);
                    },
                    child: Text("Add to Order"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Xây dựng mục trong đơn hàng
  Widget _buildOrderItem( BuildContext context,String name, String imagePath, double price, String discount,int quantity, int index) {
    final provider= Provider.of<OrderProvider>(context, listen: false);
    var order= provider.orderItems;
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(
                imagePath.startsWith('http') ? imagePath : 'assets/images/logo.png',
                height: 60,
                width: 60,
                errorBuilder: (context, error, stackTrace) {
                  // Nếu không thể tải hình ảnh từ URL, hiển thị hình ảnh mặc định
                  return Image.asset('assets/images/logo.png', height: 60, width: 60);
                },
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("₫${(price*quantity).toStringAsFixed(0)}", style: TextStyle(fontSize: 16)),
                        if (discount.isNotEmpty && discount != 'null')
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                            color: Colors.red,
                            child: Text(discount + "%", style: TextStyle(color: Colors.white)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Điều chỉnh số lượng (Đổi vị trí nút trừ và nút cộng)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      updateQuantity(index, -1);
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text('${order[index]['quantity']}', style: TextStyle(fontSize: 18)),
                  IconButton(
                    onPressed: () {
                      updateQuantity(index, 1); // Tăng số lượng
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
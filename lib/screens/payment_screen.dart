import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:golheal_app/controllers/payment_controller.dart';
import 'package:golheal_app/models/order_model.dart';
import 'package:golheal_app/providers/order_provider.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> orderItems;

  PaymentScreen({required this.orderItems});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentController paymentController =
      Get.put(PaymentController(paymentRepository: Get.find()));
  bool isQrCodeSelected = false;
  bool isCashSelected = false;// Biến để theo dõi việc chọn phương thức QR Code

  String formattedDateTime = ""; // Tạo biến lưu trữ thời gian hiện tại
  Timer? timer; // Khai báo Timer

  @override
  void initState() {
    super.initState();
    // Khởi tạo giá trị thời gian hiện tại ngay khi vào trang
    formattedDateTime = DateFormat("MMMM, d'th' yyyy, h:mm a")
        .format(DateTime.now())
        .toUpperCase();

    // Cập nhật thời gian mỗi giây
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        formattedDateTime = DateFormat("MMMM, d'th' yyyy, h:mm a")
            .format(DateTime.now())
            .toUpperCase();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // Hủy timer khi widget không còn hiển thị
    super.dispose();
  }

  void removeItem(int index) {
    setState(() {
      widget.orderItems.removeAt(index); // Xóa món ăn tại chỉ số index
    });
  }

  void _showQrCodePopup(BuildContext context, String qrCodeUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Scan this QR Code to Pay"),
          content: Image.network(qrCodeUrl), // Hiển thị mã QR
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _createOrder();
                _showSuccessPopup(context);
              },
              child: Text("Payment Completed"),
            ),
          ],
        );
      },
    );
  }

  void _createOrder() async {
    List<Products> products = widget.orderItems.map((item) {
      return Products(
        productName: item['product-name'],
        quantity: item['quantity'],
        price: item['price'],
      );
    }).toList();

    Order order = Order(products: products);
    await paymentController.createOrder(order);
  }
  void _showSuccessPopup(BuildContext context) {
    int countdown = 5; // Bắt đầu từ 5 giây

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Khởi tạo Timer bên trong StatefulBuilder
            Timer? timer;
            timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
              setState(() {
                if (countdown == 0) {
                  t.cancel(); // Hủy timer khi đếm ngược về 0
                  Get.offAllNamed('/homepage'); // Điều hướng về trang homepage
                  clearOrder(); // Xóa toàn bộ món ăn sau khi thanh toán
                } else {
                  countdown--; // Giảm 1 giây
                }
              });
            });

            return AlertDialog(
              title: Text("Payment Successful!"),
              content: Text(
                "Thank you for your payment. You will be redirected to the homepage in $countdown seconds.",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    timer?.cancel(); // Hủy Timer khi nhấn nút
                    Navigator.of(context).pop(); // Đóng popup
                  },
                  child: Text("Dismiss"),
                ),
              ],
            );
          },
        );
      },
    );
  }

// Hàm clearOrder giữ nguyên
  void clearOrder() {
    setState(() {
      widget.orderItems.clear(); // Xóa hết món ăn khỏi danh sách
    });
  }
  @override
  Widget build(BuildContext context) {
    // Tính subtotal
    final orderProvider = Provider.of<OrderProvider>(context);
    List<Map<String, dynamic>> orderItems = orderProvider.orderItems;
    double subtotal = widget.orderItems.fold(0.0, (sum, item) {
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
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Quay lại màn hình Menu
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Image.asset('assets/images/logo.png', height: 60),
              ),
            ),
            SizedBox(
              width: 920,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 5.0),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formattedDateTime,
                    style: TextStyle(fontSize: 16)), // Hiển thị thời gian
                SizedBox(height: 5),
              ],
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
                _buildSidebarButton(Icons.recommend, "AI RECOMMEND", context),
                _buildSidebarButton(Icons.menu, "MENU", context),
                _buildSidebarButton(Icons.payment, "PAYMENT", context),
              ],
            ),
          ),
          // Nội dung chính
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container chứa DataTable với chiều rộng rút ngắn
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.5, // Rút ngắn chiều rộng bảng
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ORDER SUMMARY",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        // Hiển thị danh sách món ăn theo bảng
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: widget.orderItems
                                    .isEmpty // Kiểm tra xem orderItems có rỗng không
                                ? Center(
                                    child: Text(
                                      "Không có món ăn nào được chọn!",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.red),
                                    ),
                                  )
                                : DataTable(
                                    columns: [
                                      DataColumn(
                                        label: Container(
                                          width:
                                              200, // Đặt chiều rộng cố định cho tiêu đề
                                          alignment:
                                              Alignment.center, // Căn giữa
                                          child: Text('Item'), // Tiêu đề cột
                                        ),
                                      ),
                                      DataColumn(label: Text('Quantity')),
                                      DataColumn(label: Text('Price')),
                                      DataColumn(label: Text('')),
                                    ],
                                    rows: widget.orderItems.map((item) {
                                      return DataRow(cells: [
                                        DataCell(Text(item['name'])),
                                        DataCell(
                                          Center(
                                              child:
                                                  Text('${item['quantity']}')),
                                        ),
                                        DataCell(Text(
                                            '${(item['price'] * item['quantity']).toStringAsFixed(0)} VND')),
                                        DataCell(
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              removeItem(widget.orderItems
                                                  .indexOf(item));
                                            },
                                          ),
                                        ),
                                      ]);
                                    }).toList(),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Phần hiển thị giá và các nút bên phải
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 1.0),
                      child: Column(
                        children: [
                          Divider(),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("SUBTOTAL:", style: TextStyle(fontSize: 18)),
                              Text(
                                  '${(subtotal).toStringAsFixed(0)} VND',
                                  style: TextStyle(fontSize: 18)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("DISCOUNT:", style: TextStyle(fontSize: 18)),
                              Text(
                                  '${(totalDiscount).toStringAsFixed(0)} VND',
                                  style: TextStyle(fontSize: 18)),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("TOTAL:",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  '${(total).toStringAsFixed(0)} VND',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 16),
                          // Các nút phương thức thanh toán
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center, // Căn giữa
                            children: [
                              SizedBox(
                                height: 60, // Chiều cao nút
                                width: 200, // Chiều rộng nút
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isCashSelected = true; // Đánh dấu Cash đã được chọn
                                      isQrCodeSelected = false; // Đảm bảo chỉ một phương thức được chọn
                                    });
                                  },
                                  child: Text("CASH"),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20), // Đặt góc cong
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 80), // Khoảng cách giữa hai nút
                              SizedBox(
                                height: 60, // Chiều cao nút
                                width: 200, // Chiều rộng nút
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isQrCodeSelected = true;
                                      isCashSelected = false;
                                    });
                                  },
                                  child: Text("QR CODE"),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20), // Đặt góc cong
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          // Nút CANCEL và CONTINUE nằm ngang nhau và có giãn cách
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(
                                        context); // Quay lại màn hình Menu
                                  },
                                  child: Text("CANCEL"),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (isQrCodeSelected) {
                                      String qrCodeUrl =
                                          'https://img.vietqr.io/image/vietinbank-103874550713-compact2.jpg?amount=${(total).toStringAsFixed(0)}&accountName=PHAM%20LE%20NHAT%20HOANG';
                                      _showQrCodePopup(context,
                                          qrCodeUrl); // Hiển thị mã QR nếu chọn phương thức thanh toán QR
                                    } else if (isCashSelected) {
                                      // Nếu chọn Cash, tạo đơn hàng và hiển thị thông báo thành công
                                      _createOrder();
                                      _showSuccessPopup(context); // Hiển thị thông báo thành công
                                    } else {
                                      Get.snackbar("Error",
                                          "Please select QR Code or Cash payment method");
                                    }
                                  },
                                  child: Text("CONTINUE"),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.green,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Xây dựng nút sidebar
  Widget _buildSidebarButton(
      IconData icon, String label, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Chuyển hướng tới màn hình tương ứng
        if (label == "AI RECOMMEND") {
          Navigator.pop(context);
        } else if (label == "MENU") {
          Navigator.pop(context); // Quay lại màn hình Menu
        } else if (label == "PAYMENT") {
          // Đã ở trong màn hình Payment
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.black),
            SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

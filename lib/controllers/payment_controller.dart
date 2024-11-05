import 'package:get/get.dart';
import 'package:golheal_app/data/repository/payment_repository.dart';
import 'package:golheal_app/models/order_model.dart';
import 'package:golheal_app/utils/app_constants.dart';

class PaymentController extends GetxController {
  PaymentRepository paymentRepository;

  PaymentController({required this.paymentRepository});

  var isLoading = false.obs;
  var qrCodeUrl = ''.obs;

  Future<void> generateQrPayment(double totalAmountInUSD) async {
    isLoading.value = true;
    const double exchangeRate = 23000;  // Tỷ giá hối đoái từ USD sang VND
    double totalAmountInVND = totalAmountInUSD * exchangeRate;

    try {
      String url = "${AppConstants.QR_CODE}?amount=${totalAmountInVND.toStringAsFixed(0)}";
      Response response = await paymentRepository.createQrPayment(url);

      if (response.statusCode == 200) {
        qrCodeUrl.value = response.body['qrCodeUrl'];
      } else {
        Get.snackbar("Error", "Failed to generate QR code");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchSecondUrl(String firstUrl) async {
    try {
      Response response = await paymentRepository.createQrPayment(firstUrl);

      if (response.statusCode == 200) {
        // Giả sử response chứa đường dẫn thứ 2 trong trường 'nextUrl'
        String secondUrl = response.body['nextUrl'];

        // Gọi hàm để tạo mã QR từ đường dẫn thứ 2
        await generateQrPaymentWithUrl(secondUrl);
      } else {
        Get.snackbar("Error", "Failed to fetch second URL");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Hàm tạo mã QR từ đường dẫn được truyền vào
  Future<void> generateQrPaymentWithUrl(String secondUrl) async {
    isLoading.value = true;

    try {
      Response response = await paymentRepository.createQrPayment(secondUrl);

      if (response.statusCode == 200) {
        qrCodeUrl.value = response.body['qrCodeUrl'];
        // Hiển thị popup mã QR
        Get.snackbar("Success", "QR code generated");
      } else {
        Get.snackbar("Error", "Failed to generate QR code");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  // Method to create order after payment is done
  Future<void> createOrder(Order order) async {
    try {
      Response response = await paymentRepository.createOrder(order);
      if (response.statusCode == 200) {
        Get.snackbar("Success", "Order created successfully");
      } else {
        Get.snackbar("Error", "Failed to create order");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:golheal_app/controllers/user_controller.dart';
import 'package:golheal_app/models/login_model.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Tài khoản test cứng
  final String correctUsername = 'test';
  final String correctPassword = '1234';
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context, listen:true).removeToken();
    return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.purple),
              onPressed: () {
                Navigator.pop(context); // Quay lại màn hình trước đó
              },
            ),
          ),
          body: GetBuilder<UserController>(builder: (userController) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'BRAND LOGIN',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7E57C2),
                      ),
                    ),
                    SizedBox(height: 40),
                    _buildTextField(
                        Icons.person, 'Username', _usernameController),
                    SizedBox(height: 20),
                    _buildTextField(Icons.lock, 'Password', _passwordController,
                        isPassword: true),
                    SizedBox(height: 20),
                    SizedBox(height: 40),
                    ElevatedButton(
                      autofocus: true,
                      onPressed: () async {
                        // Lấy giá trị nhập vào từ người dùng
                        String username = _usernameController!.text;
                        String password = _passwordController!.text;
                        var data =
                            LoginModel(password: password, userName: username);

                        // Gọi hàm login từ UserController
                        bool loginSuccess =
                            await userController.login(data: data);

                        if (loginSuccess) {
                          // Chuyển sang trang HomeTablet() nếu đăng nhập thành công
                          Get.toNamed('/homepage');
                        } else {
                          // Hiển thị thông báo lỗi nếu đăng nhập thất bại
                          Get.snackbar(
                            'Login Failed',
                            'Incorrect username or password',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.purple,
                      ),
                      child: Text('LOGIN',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }));
  }

  Widget _buildTextField(
      IconData icon, String hintText, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      autofocus: true,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        filled: true,
        fillColor: Color(0xFFF3E5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

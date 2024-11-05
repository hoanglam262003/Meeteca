class LoginModel {
  String? userName;
  String? password;

  LoginModel({this.userName, this.password});

  LoginModel.fromJson(Map<String, dynamic> json) {
    userName = json['user-name'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user-name'] = this.userName;
    data['password'] = this.password;
    return data;
  }
}
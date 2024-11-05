class AppConstants{
  static const String APP_NAME = "Meeteca";
  static const String APP_VERSION = "1.0.0";
  static const String BaseUrl = "https://meetecamenu-ekcmczc6ghdjdrgk.canadacentral-01.azurewebsites.net";
  ///Notification
  static const String UNAVAILABLE_TITLE_NOTI = 'Tính năng đang phát triển';
  static const String UNAVAILABLE_DESC_NOTI = 'Mời bạn quay lại sau!';
  static const String POST_LOGIN = "/api/authentication/login-mobile";
  static const String QR_CODE = "/api/payment/create-qr-payment";
  static const String ADD_ORDER = "/api/orders/add";
  static const String GET_CATEGORY = "/api/categories/get-by-brand-id";
  static const String GET_BRAND = "/api/stores/get-brand-of-store-by-user-id";
  static const String RECOMMEND_MENU = "/api/menus/recommend-menu";
  static const String GET_PROD_BY_CATE = "/api/products/get-by-category-name";
}
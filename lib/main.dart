import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get_storage/get_storage.dart';
import 'package:golheal_app/dependencies/dependencies.dart';
import 'package:golheal_app/providers/user_provider.dart';
import 'package:golheal_app/screens/ai_menu_tablet.dart';
import 'package:golheal_app/screens/home_tablet.dart';
import 'package:golheal_app/screens/login_tablet.dart';
import 'package:golheal_app/screens/menu_screen.dart';
import 'package:golheal_app/screens/start_tablet.dart';
import 'package:flutter/services.dart';
import 'package:golheal_app/utils/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:golheal_app/providers/order_provider.dart';

void main() async{
  await GetStorage.init();
  await GetXDependencies.init();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => OrderProvider()), // Khởi tạo OrderProvider
          ChangeNotifierProvider(create: (_) => UserProvider()), // Khởi tạo OrderProvider
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(
            name: '/',
            page: () => SplashScreen(),
            transition: Transition.rightToLeft,),
        GetPage(
            name: '/login',
            page: () => LoginScreen(),
            transition: Transition.rightToLeft),
        GetPage(
            name: '/menu',
            page: () => MenuScreen(),
            transition: Transition.rightToLeft),
        GetPage(
            name: '/aimenu',
            page: () => AIMenuScreen(),
            transition: Transition.rightToLeft),
        GetPage(
            name: '/homepage',
            page: () => HomeTablet(),
            transition: Transition.rightToLeft),
      ],
      title: AppConstants.APP_NAME,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
    );
  }
}

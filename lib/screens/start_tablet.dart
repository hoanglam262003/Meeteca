import 'dart:async';
import 'package:flutter/material.dart';
import 'package:golheal_app/screens/login_tablet.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final List<String> _images = [
    'assets/images/background_1.png', // Hình nền 1
    'assets/images/background_2.png', // Hình nền 2
    'assets/images/background_3.png', // Hình nền 3
  ];

  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startImageTransition();
  }

  void _startImageTransition() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _images.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Hình nền động
            AnimatedSwitcher(
              duration: Duration(seconds: 2),
              child: Image.asset(
                _images[_currentIndex],
                key: ValueKey<String>(_images[_currentIndex]),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
              ),
            ),

            // Text "Welcome to Meeteca" ở giữa màn hình, phía trên
            Positioned(
              top: screenSize.height * 0.45, // Vị trí cách đỉnh 30% chiều cao màn hình
              left: 0,
              right: 0,
              child: Text(
                'Welcome to Meeteca',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // Text "Meeteca is a smart application..." ở dưới đáy màn hình và căn giữa
            Positioned(
              bottom: 20, // Cách đáy màn hình 20px
              left: 0,
              right: 0,
              child: Text(
                'Meeteca is a smart application.\nThe application uses AI technology to suggest dishes for you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.greenAccent,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
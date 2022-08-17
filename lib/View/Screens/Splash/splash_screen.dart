import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/View/Screens/Splash/splash_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      splashIconSize: screenHeight(context),
      duration: 0,
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/smart_loading.gif",
            scale: 3,
            fit: BoxFit.scaleDown,
          ),
          SizedBox(
            height: screenHeight(context) * 0.1,
          ),
          const CircularProgressIndicator(
            color: Colors.yellow,
          )
        ],
      ),
      backgroundColor: Colors.white,
      screenFunction: () async {
        return await context.read<SplashViewmodel>().loadingFunction(context);
      },
    );
  }
}

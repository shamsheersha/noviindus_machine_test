import 'dart:async';
import 'package:ayurved_care/providers/auth_provider.dart';
import 'package:ayurved_care/screens/home_screen.dart';
import 'package:ayurved_care/screens/login_screen.dart';
import 'package:ayurved_care/utils/custom_pagerout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

  }

  Future<void> _checkAuthAndNavigate(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    while (authProvider.isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Widget nextScreen = authProvider.isAuthenticated
        ? const HomeScreen()
        : const LoginScreen();
    Navigator.pushReplacement(
      context,
      CustomPageRoute(child: nextScreen, direction: AxisDirection.left),
    );
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkAuthAndNavigate(context),
      builder: (context, snapshot) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Splash Screen.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}

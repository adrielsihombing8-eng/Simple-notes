import 'package:flutter/material.dart';
import 'package:login_ui/Login_page.dart';
import 'package:login_ui/dashboard.dart';
import 'package:login_ui/services/api.dart';

class SplashChecker extends StatefulWidget {
  final String? token;
  const SplashChecker({required this.token,super.key});

  @override
  State<SplashChecker> createState() => _SplashCheckerState();
}

class _SplashCheckerState extends State<SplashChecker> {
  @override
  void initState() {
    super.initState();
    tokenCheck();
  }

  Future<void> tokenCheck() async {
    final bool isToken = await Api.cekAuth(widget.token!);
    print("masuk ke auth dengan nilai $isToken");

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => isToken ? Dashboard(token: widget.token) : LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}

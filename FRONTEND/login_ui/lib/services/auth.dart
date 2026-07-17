import 'package:flutter/material.dart';
import 'package:login_ui/presentation/Login_page.dart';
import 'package:login_ui/modules/dashboard.dart';
import 'package:login_ui/services/api.dart';

class SplashChecker extends StatefulWidget {
  final String? token;
  const SplashChecker({required this.token, super.key});

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
        builder: (context) =>
            isToken ? Dashboard() : LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

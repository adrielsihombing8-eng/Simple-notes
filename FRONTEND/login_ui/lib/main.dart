import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:login_ui/Login_page.dart';
import 'package:login_ui/Register_Page.dart';
import 'package:login_ui/services/auth.dart';
import 'package:login_ui/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  if(pref.getString("token") != null){
    String? token = pref.getString("token");
    runApp(MainApp(token: token,isToken: true));
  }
  else{
    runApp(const MainApp(token: null,isToken: false));
  }
}

class MainApp extends StatelessWidget {
  final bool isToken;
  final String? token;
  const MainApp({required this.isToken,required this.token,super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: getHome(),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget getHome(){
    if(token != null && JwtDecoder.isExpired(token!) == false){
      var routes = SplashChecker(token: token);
      return routes;
    }
    else if(token == null || JwtDecoder.isExpired(token!) == true){
      return LoginPage();
    }
    else{
      return LoginPage();
    }
  }
}

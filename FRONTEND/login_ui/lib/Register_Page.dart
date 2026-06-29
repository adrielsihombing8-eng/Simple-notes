import 'package:flutter/material.dart';
import 'package:login_ui/Login_page.dart';
import 'package:login_ui/services/api.dart';

class AppFirstLook extends StatefulWidget {
  const AppFirstLook({super.key});

  @override
  State<AppFirstLook> createState() => _AppFirstLookState();
}

class _AppFirstLookState extends State<AppFirstLook> {
  var nameCtrl = new TextEditingController();
  var passwordCtrl = new TextEditingController();
  var konfirmPw = new TextEditingController();
  bool isValidUser = true;
  bool isValidPw = true;
  bool isSame = true;
  String pesan1 = "";
  String pesan2 = "";
  String pesan3 = "";

  void Register() async {
    if (nameCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      if (nameCtrl.text.isEmpty) {
        setState(() {
          isValidUser = false;
          pesan1 = "email masih kosong";
          isValidPw = true;
          pesan2 = "";
        });
      }
      if (passwordCtrl.text.isEmpty) {
        setState(() {
          isValidPw = false;
          pesan2 = "password masih kosong";
          isValidUser = true;
          pesan1 = "";
        });
      }
      if (nameCtrl.text.isEmpty && passwordCtrl.text.isEmpty) {
        setState(() {
          isValidUser = false;
          pesan1 = "email masih kosong";
          isValidPw = false;
          pesan2 = "password masih kosong";
        });
      }
    } else if (passwordCtrl.text != konfirmPw.text) {
      setState(() {
        isSame = false;
        pesan3 = "password dan konfirmasi \ntidak sama";
      });
    } else {
      setState(() {
        isValidUser = true;
        isValidPw = true;
        isSame = true;
        pesan1 = "";
        pesan2 = "";
        pesan3 = "";
      });

      var pdata = {
        "email": nameCtrl.text.toString(),
        "password": passwordCtrl.text.toString(),
      };

      Api.register(pdata);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0052D4),
                Color(0xFF4364F7),
                Color(0xFF4364F7),
                Color(0xFF6FB1FC),
                Color(0xFF6FB1FC),
              ],
              begin: AlignmentGeometry.topLeft,
              end: AlignmentGeometry.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 450,
                          width: 280,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(20),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Column(
                              children: [
                                SizedBox(height: 60),
                                SizedBox(
                                  width: 250,
                                  child: TextField(
                                    controller: nameCtrl,
                                    decoration: InputDecoration(
                                      errorText: isValidUser ? null : pesan1,
                                      labelText: 'user account',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                      
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          width: 2.0,
                                        ),
                                      ),
                      
                                      errorBorder: isValidUser
                                          ? null
                                          : OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(
                                                12.0,
                                              ),
                                              borderSide: BorderSide(
                                                color: Colors.red,
                                                width: 1.0,
                                              ),
                                            ),
                      
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                      
                                SizedBox(height: 15),
                                SizedBox(
                                  width: 250,
                                  child: TextField(
                                    controller: passwordCtrl,
                                    decoration: InputDecoration(
                                      errorText: isValidPw ? null : pesan2,
                                      labelText: 'password account',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                      
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          width: 2.0,
                                        ),
                                      ),
                      
                                      errorBorder: isValidPw
                                          ? null
                                          : OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(
                                                12.0,
                                              ),
                                              borderSide: BorderSide(
                                                color: Colors.red,
                                                width: 1.0,
                                              ),
                                            ),
                      
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                      
                                SizedBox(height: 15),
                                SizedBox(
                                  width: 250,
                                  child: TextField(
                                    controller: konfirmPw,
                                    decoration: InputDecoration(
                                      errorText: isSame ? null : pesan3,
                                      labelText: 'confirm password',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                      
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          width: 2.0,
                                        ),
                                      ),
                      
                                      errorBorder: isSame
                                          ? null
                                          : OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(
                                                12.0,
                                              ),
                                              borderSide: BorderSide(
                                                color: Colors.red,
                                                width: 1.0,
                                              ),
                                            ),
                      
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                      
                                SizedBox(height: 30),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () => Register(),
                                  child: Text("Register"),
                                ),
                      
                                Row(
                                  children: [
                                    SizedBox(width: 45),
                                    Text("have any account?"),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginPage(),
                                          ),
                                        );
                                      },
                                      child: Text("Login"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      
                        Positioned(
                          top: -20,
                          left: 100,
                          child: Container(
                            height: 70,
                            width: 70,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              child: Icon(Icons.shopping_bag),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text("created by adrielsihombing, ver 0.0.1"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

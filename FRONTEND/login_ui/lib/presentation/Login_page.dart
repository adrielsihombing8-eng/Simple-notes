import 'package:flutter/material.dart';
import 'package:login_ui/presentation/Register_Page.dart';
import 'package:login_ui/modules/dashboard.dart';
import 'package:login_ui/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var nameCtrl = new TextEditingController();
  var passwordCtrl = new TextEditingController();
  var konfirmPw = new TextEditingController();
  bool isValidUser = true;
  bool isValidPw = true;
  String pesan1 = "";
  String pesan2 = "";

  late SharedPreferences pref;

  @override
  void initState() {
    initSharePref();
    super.initState();
  }

  void initSharePref() async{
    pref = await SharedPreferences.getInstance();
  }

  void Login() async {
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
    } else {
      setState(() {
        isValidUser = true;
        isValidPw = true;
        pesan1 = "";
        pesan2 = "";
      });

      var pdata = {
        "email": nameCtrl.text.toString(),
        "password": passwordCtrl.text.toString(),
      };

      var earn = await Api.Login(pdata);
      print(earn['status']);
      print(earn);
      if(earn['status'] == true){
        var MyToken = earn['token'];
        pref.setString('token', MyToken);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
      else{
        print(" error 81 : " + earn['messages'].toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 38, 35, 35),
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
              child: IntrinsicHeight(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 440,
                            width: 280,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(20),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Column(
                                children: [
                                  SizedBox(height: 60),
                                  Text("Selamat Datang \n Silahkan Login", style: TextStyle(fontSize: 20, color: Colors.blueAccent, fontWeight: FontWeight.w800),),
                                  SizedBox(height: 20,),
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
                                  
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () => Login(),
                                    child: Text("Login"),
                                  ),
                        
                                  Row(
                                    children: [
                                      SizedBox(width: 25),
                                      Text("don't have any account?"),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AppFirstLook()));
                                        },
                                        child: Text("Register"),
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
                                child: Icon(Icons.book_outlined),
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
      ),
    );
  }
}
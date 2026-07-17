import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:login_ui/modules/Home/NoteScreen.dart';
import 'package:login_ui/modules/Home/home_screen.dart';
import 'package:login_ui/modules/note/note_collection.dart';
import 'package:login_ui/modules/profile/profil_screen.dart';
import 'package:login_ui/presentation/Login_page.dart';
import 'package:login_ui/services/auth_store.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? email;
  int selectIndex = 0;

  @override
  void initState() {
    super.initState();
    loadEmail();
  }

  Future<void> loadEmail() async {
    var token = await AuthStore.getToken();
    if(token == null) {
      if(mounted){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
      return;
    };
    var payload = JwtDecoder.decode(token);
    setState(() {
      email = payload['email'];
    });
  }

  List<Widget> get widgetOption => <Widget>[
    HomeScreen(email: email!),
    NoteCollection(),
    ProfilScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    if (email == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 38, 35, 35),
      body: widgetOption[selectIndex],
      bottomNavigationBar: SafeArea(
        child: isKeyboardOpen? SizedBox.shrink() : Container(
          margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 3.0),
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SizedBox(
            height: 60,
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconSize: 20,
              selectedFontSize: 12,
              showUnselectedLabels: false,
              currentIndex: selectIndex,
              selectedItemColor: Colors.white,
              onTap: onItemTapped,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.note_alt_outlined),
                  label: 'Note',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: 'Profiles',
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}

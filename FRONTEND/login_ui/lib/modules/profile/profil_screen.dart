import 'dart:math';

import 'package:flutter/material.dart';
import 'package:login_ui/modules/profile/circleVideo.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  late String user;

  @override
  void initState() {
    loadScreen();
    super.initState();
  }

  void loadScreen() async{
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 35, 35),
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Row(
          children: [
            Icon(Icons.book_outlined),
            SizedBox(width: 5,),
            Text("Adriel Sihombing", style: TextStyle(),)
          ],
        ),
        actions: [
          //ganti warna latarbelakang entaran
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          children: [
                            Circlevideo(VideoPath: "assets/videos/GI.mp4"),

                            SizedBox(width: 14,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama Pengguna", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                Text("account pengguna", style: TextStyle(),)
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          children: [
                            Text("Gatau mau isi apa")
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]
          ),
        )
      ),
    );
  }
}
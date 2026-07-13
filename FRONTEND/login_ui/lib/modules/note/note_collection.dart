import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:login_ui/models/kategori_models.dart';
import 'package:login_ui/modules/note/note_listCategory.dart';
import 'package:login_ui/presentation/Login_page.dart';
import 'package:login_ui/services/auth_store.dart';

class NoteCollection extends StatefulWidget {
  const NoteCollection({super.key});

  @override
  State<NoteCollection> createState() => _NoteCollectionState();
}

class _NoteCollectionState extends State<NoteCollection> {
  String? token;

  List<KategoriModels> items = [
    KategoriModels(kategori: "None", quotes: "Split it; it makes your management increas"),
    KategoriModels(kategori: "Work", quotes: "Getting busy right now?"),
    KategoriModels(kategori: "Sport", quotes: "Healty body, healty mind"),
    KategoriModels(kategori: "Home", quotes: "Home sweet home"),
    KategoriModels(kategori: "Experiance", quotes: "My trip, my adventure"),
    KategoriModels(kategori: "Task", quotes: "You should finishing it bro.."),
    KategoriModels(kategori: "Shopping", quotes: "Daily need huhhh..."),
  ];//ini sebagai contoh call api

  @override
  void initState() {
    loadToken();
    super.initState();
  }

  Future<void> loadToken() async{
    final t = await AuthStore.getToken();

    if(t == null){
      if(mounted){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
      return;
    }

    if(mounted){
      setState(() {
        token = t;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 35, 35),
      appBar: AppBar(
        leading: Icon(Icons.note_add_rounded, color: Colors.white),
        backgroundColor: Colors.grey,
        title: Text("Note Data", style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          bool isNewCategory =
              index == 0 || item.kategori != items[index - 1].kategori;

          if (isNewCategory) {
            return Card(
              child: ListTile(
                leading: Icon(Icons.storage),
                title: Text("${item.kategori}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                subtitle: Text("${item.quotes}"),
                dense: true,
                trailing: Icon(Icons.drag_handle),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteListcategory(
                        kategori: item.kategori.toString(),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}

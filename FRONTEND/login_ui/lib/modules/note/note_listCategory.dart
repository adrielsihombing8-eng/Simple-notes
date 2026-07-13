import 'package:flutter/material.dart';
import 'package:login_ui/models/library_models.dart';
import 'package:login_ui/models/note_models.dart';
import 'package:login_ui/presentation/Login_page.dart';
import 'package:login_ui/services/api.dart';
import 'package:login_ui/services/auth_store.dart';

class NoteListcategory extends StatefulWidget {
  final String kategori;
  const NoteListcategory({required this.kategori, super.key});

  @override
  State<NoteListcategory> createState() => _NoteListcategoryState();
}

class _NoteListcategoryState extends State<NoteListcategory> {
  var searchCtrl = new TextEditingController();
  bool isSearch = false;
  Future<List<NoteModels>>? library;

  @override
  void initState() {
    pdata();
    super.initState();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  void dataNoteFind() async {
    String? filter = searchCtrl.text.isEmpty
        ? null
        : searchCtrl.text.toString();
    final t = await AuthStore.getToken();

    if (t == null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
      return;
    }

    if (mounted) {
      if (filter != null) {
        setState(() {
          library = Api.getNoteInKategory(widget.kategori, filter, t)
              .catchError((err) {
                if (err.toString().contains('SESSION_EXPIRED')) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              });
        });
      } else {
        setState(() {
          library = Api.getNoteByKategory(widget.kategori, t).catchError((err) {
            if (err.toString().contains('SESSION_EXPIRED')) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
          });
        });
      }
    }
  }

  Future<void> pdata() async {
    final token = await AuthStore.getToken();

    if (token == null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
      return;
    }

    print("pencarian data pertama");
    var notesData = Api.getNoteByKategory(widget.kategori, token).catchError((err) {
      if (err.toString().contains('SESSION_EXPIRED')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });

    setState(() {
      library = notesData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 38, 35, 35),
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(widget.kategori, style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (isSearch == true) {
                  isSearch = false;
                } else {
                  isSearch = true;
                }
              });
            }, // mencari di data library
            icon: CircleAvatar(
              backgroundColor: isSearch ? Colors.lightBlue : Colors.grey,
              child: Icon(
                Icons.search,
                color: isSearch ? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      ),

      body: Container(
        child: Column(
          children: [
            SizedBox(height: isSearch ? 10 : 0),

            isSearch
                ? Container(
                    width: MediaQuery.of(context).size.width - 30,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 4),
                        const Icon(Icons.search),
                        SizedBox(width: 8),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: TextField(
                              controller: searchCtrl,
                              decoration: const InputDecoration(
                                hintText: 'Cari sesuatu...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),

            SizedBox(height: isSearch ? 30 : 0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: library,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Gagal memuat catatan: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData ||
                        (snapshot.data as List).isEmpty) {
                      return Center(
                        child: Text(
                          'Belum ada catatan',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      );
                    } else {
                      List<NoteModels> notesDatas =
                          snapshot.data as List<NoteModels>;

                      return ListView.builder(
                        itemCount: notesDatas.length,
                        itemBuilder: (context, index) {
                          final items = notesDatas[index];

                          return Card(
                            child: ListTile(
                              leading: Icon(Icons.storage),
                              title: Text(
                                "${items.title}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                "${items.pref}",
                                style: TextStyle(),
                              ),
                              dense: true,
                              trailing: Icon(Icons.drag_handle),
                              onTap: () {},
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

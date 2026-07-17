import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:login_ui/models/note_models.dart';
import 'package:login_ui/modules/Home/NoteScreen.dart';
import 'package:login_ui/modules/Home/widget/BuildTimeLine.dart';
import 'package:login_ui/presentation/Login_page.dart';
import 'package:login_ui/services/api.dart';
import 'package:login_ui/services/auth_store.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({required this.email, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? token;
  DateTime selectedDate = DateTime.now();
  DateTime dateGet = DateTime.now();
  bool isChange = false;
  Future<List<NoteModels>>? noteApi;
  bool isSearch = false;
  bool isDelating = false;

  var searchCtrl = new TextEditingController();
  final Set<String> selectedIds = {};

  @override
  void initState() {
    super.initState();
    LoadNoteandToken();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  void detectDelate(String id) {
    setState(() {
      isDelating = true;
      selectedIds.add(id);
    });
  }

  void DelateNote() async {
    var t = await AuthStore.getToken();
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
      setState(() {
        token = t;
        Api.delateNote(t, selectedIds).catchError((err) {
          if (err..toString().contains("SESSION_EXCEPTION")) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
        });
        selectedIds.clear();
        isDelating = false;
        noteApi = Api.getNote(t).catchError((err) {
          if (err.toString().contains("SESSION_EXPIRED")) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
        });
      });
    } else {
      return;
    }
  }

  void onCheckChanged(String id, bool isChecked) {
    setState(() {
      if (isChecked) {
        selectedIds.add(id);
      } else {
        selectedIds.remove(id);
      }

      if (selectedIds.isEmpty) {
        isDelating = false;
      }
    });
  }

  void LoadNoteandToken() async {
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
      setState(() {
        token = t;
        noteApi = Api.getNote(t).catchError((err) {
          if (err.toString().contains('SESSION_EXPIRED')) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
          throw err;
        });
      });
    }
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
        print(filter);
        setState(() {
          noteApi = Api.getNoteByName(filter, t).catchError((err) {
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
          noteApi = Api.getNote(t).catchError((err) {
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

  List<DateTime> getDateTime() {
    return List.generate(7, (index) => dateGet.add(Duration(days: index)));
  }

  String getDayName(DateTime date) {
    const day = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return day[date.weekday - 1];
  }

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Color(0xFF262323),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF262323),
          ),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: Center(
              child: SizedBox(width: 400, height: 500, child: child),
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        dateGet = picked;
        selectedDate = picked;
        if (dateGet != DateTime.now()) {
          isChange = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    if (noteApi == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey,
      appBar: AppBar(
        leading: Icon(Icons.note_add_rounded, color: Colors.white),
        backgroundColor: Colors.grey,
        title: Text("NoteIt", style: TextStyle(color: Colors.white)),
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
            },
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
      body: Stack(
        children: [
          Positioned(
            top: 15,
            height: 80,
            right: 0,
            left: 0,
            child: buildDate(),
          ),

          Positioned(
            top: 5,
            height: 100,
            width: 80,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        selectDate();
                      },
                      icon: Icon(Icons.date_range_outlined, size: 30),
                    ),
                    Text(
                      "Kalender",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (isChange)
            Positioned(
              top: 90,
              right: MediaQuery.of(context).size.width / 2 - 30,
              height: 25,
              width: 90,
              child: Container(
                color: Colors.transparent,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isChange = false;
                      dateGet = DateTime.now();
                      selectedDate = DateTime.now();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    "Reset",
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 38, 35, 35),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                child: FutureBuilder(
                  future: noteApi,
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
                      List<NoteModels> note = snapshot.data as List<NoteModels>;

                      return ListView.builder(
                        itemCount: note.length,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final items = note[index];
                          final bool isNewDate =
                              index == 0 || note[index - 1].date != items.date;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isNewDate) ...[
                                BuildDataBadge(items.date, isToday: index == 0),
                              ],
                              Buildtimeline(
                                item: items,
                                onCheckChanged: (bool isChecked) =>
                                    onCheckChanged(items.objectId, isChecked),
                                onLongPress: () => detectDelate(items.objectId),
                                isSelectionmode: isDelating,
                                isChecked: selectedIds.contains(items.objectId),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ),

          isSearch
              ? Positioned(
                  top: 0,
                  height: 40,
                  right: MediaQuery.of(context).size.width / 2 - 140,
                  child: Container(
                    width: 280,
                    height: 80,
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
                              onSubmitted: (value) {
                                dataNoteFind();
                              },
                              decoration: const InputDecoration(
                                hintText: 'Cari sesuatu...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ),

                        CircleAvatar(
                          backgroundColor: Colors.lightBlue,
                          foregroundColor: Colors.white,
                          child: IconButton(
                            onPressed: () {
                              dataNoteFind();
                            },
                            icon: Icon(Icons.send),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),

      floatingActionButton: Padding(
        padding: EdgeInsetsGeometry.only(bottom: isKeyboardOpen ? 0 : 150),
        child: isDelating
            ? FloatingActionButton(
                onPressed: () {
                  DelateNote();
                },
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.delete_outline, color: Colors.white),
                shape: CircleBorder(
                  side: BorderSide(color: Colors.white, width: 2.0),
                ),
              )
            : FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Notescreen()),
                  );

                  if (result == true) {
                    setState(() {
                      noteApi = Api.getNote(token!);
                    });
                  }
                  ;
                },

                backgroundColor: Colors.blue,
                child: Icon(Icons.add, color: Colors.white),
                shape: CircleBorder(
                  side: BorderSide(color: Colors.white, width: 2.0),
                ),
              ),
      ),
    );
  }

  Widget buildDate() {
    final dates = getDateTime();

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected =
              date.day == selectedDate.day &&
              date.month == selectedDate.month &&
              date.year == selectedDate.year;

          return GestureDetector(
            onTap: () => setState(() {
              selectedDate = date;
            }),
            child: Container(
              width: 55,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getDayName(date),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget BuildDataBadge(String date, {bool isToday = false}) {
  return IntrinsicHeight(
    child: Row(
      children: [
        Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 1),
              child: Column(
                children: [
                  Expanded(child: Container(width: 2, color: Colors.grey[700])),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Container(height: 32, width: 2, color: Colors.grey[700]),
                ],
              ),
            ),
            Positioned(
              top: 30,
              left: 9,
              bottom: 30,
              child: Row(
                children: [
                  Container(height: 3, width: 20, color: Colors.grey[700]),
                ],
              ),
            ),
          ],
        ),

        Row(
          children: [
            Container(height: 2, width: 40, color: Colors.grey[700]),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 20, left: 0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isToday ? Colors.blue : Colors.grey[700],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  date,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

bool DateToday(String dateString) {
  final DateTime itemDate = DateTime.parse(dateString);
  final DateTime now = DateTime.now();

  return itemDate.year == now.year &&
      itemDate.month == now.month &&
      itemDate.day == now.day;
}

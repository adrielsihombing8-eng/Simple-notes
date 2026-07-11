import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_ui/models/note_models.dart';
import 'package:login_ui/services/api.dart';

class Notescreen extends StatefulWidget {
  final String token;
  const Notescreen({required this.token, super.key});

  @override
  State<Notescreen> createState() => _NotescreenState();
}

class _NotescreenState extends State<Notescreen> {
  var titleCtrl = new TextEditingController();
  var descCtrl = new TextEditingController();
  var dateController = new TextEditingController();
  var timeCtrl = new TextEditingController();

  bool isSaving = false;
  String pilih = "None";

  @override
  void initState() {
    titleCtrl.text = "Note";
    dateController.text = DateTime.now().toString().split(" ")[0];
    timeCtrl.text =
        DateTime.now().toString().split(" ")[1].split(":")[0] +
        " : " +
        DateTime.now().toString().split(" ")[1].split(":")[1];
    super.initState();
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    timeCtrl.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> storeNote() async {
    var data = {
      "title": titleCtrl.text.isEmpty
          ? "Note"
          : titleCtrl.text.toString().toUpperCase(),
      "pref": pilih,
      "date": dateController.text.toString(),
      "time": timeCtrl.text.toString(),
      "description": descCtrl.text.toString(),
    };

    Api.createNote(data, widget.token);
  }

  final List<Map<String, dynamic>> dropdownItem = [
    {'nama' : 'None', 'icon' : Icons.info_outline},
    {'nama' : 'Sport', 'icon' : Icons.sports},
    {'nama' : 'Home', 'icon' : Icons.home},
    {'nama' : 'Work', 'icon' : Icons.work},
    {'nama' : 'Experience', 'icon' : Icons.history},
    {'nama' : 'Task', 'icon' : Icons.task_alt},
    {'nama' : 'Shopping', 'icon' : Icons.wallet},
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (isSaving) {
          return;
        }

        setState(() {
          isSaving = true;
        }); //sama aja
        await storeNote();
        setState(() => isSaving = false); // sama aja

        if (context.mounted) {
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 38, 35, 35),
        appBar: AppBar(
          title: const Text("Note"),
          backgroundColor: Colors.grey,
          leading: IconButton(
            onPressed: () async {
              await storeNote();
              if (context.mounted) Navigator.pop(context, true);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  TextField(
                    controller: titleCtrl,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [UpperCaseTextFormatter()],
                    decoration: InputDecoration(
                      labelText: "Title",
                      labelStyle: TextStyle(
                        fontSize: 25,
                        color: Colors.white24,
                      ),
                      icon: Icon(
                        Icons.edit_note,
                        color: Colors.white54,
                        size: 30,
                      ),
                      hintText: "Mulai di sini...",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.lightBlue),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  Container(
                    child: Row(
                      children: [
                        Icon(Icons.date_range, color: Colors.white54, size: 17),
                        SizedBox(width: 5),
                        Text(
                          "Time : ",
                          style: TextStyle(fontSize: 15, color: Colors.white54),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 20,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: dateController.text,
                                  hintStyle: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white54,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[700],
                                  prefixIcon: Icon(
                                    Icons.calendar_today,
                                    size: 17,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.watch_later_outlined,
                          color: Colors.white54,
                          size: 17,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Date : ",
                          style: TextStyle(fontSize: 15, color: Colors.white54),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 20,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: timeCtrl.text,
                                  hintStyle: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white54,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[700],
                                  prefixIcon: Icon(
                                    Icons.watch_later_outlined,
                                    size: 17,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),
                  Container(
                    height: 45,
                    child: Row(
                      children: [
                        Icon(Icons.visibility, color: Colors.white54, size: 17),
                        SizedBox(width: 5),
                        Text(
                          "Preview : ",
                          style: TextStyle(fontSize: 15, color: Colors.white54),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 80,
                              top: 10,
                            ),
                            child: SizedBox(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[700],
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey[700]!,
                                    width: 1,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: pilih,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white54,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        pilih = newValue!;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    dropdownColor: Colors.white54,
                                    items: dropdownItem
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item['nama'] as String,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    item['icon'] as IconData,
                                                    size: 16,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(item['nama'] as String),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),
                  Text(
                    "Catatan",
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: TextField(
                      controller: descCtrl,
                      maxLines: null,
                      minLines: 3,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: "Tulis catatanmu di sini...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 15, bottom: 30),
          child: FloatingActionButton.extended(
            onPressed: () {
              storeNote();
              Navigator.pop(context, true);
            },
            label: const Text('Save'),
            icon: Icon(Icons.save_outlined, color: Colors.white),
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
          ),
        ),

        bottomNavigationBar: SafeArea(
          child: Container(
            color: Colors.transparent,
            height: 50,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "VER 0.0.1",
                  style: TextStyle(fontSize: 12, color: Colors.white54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

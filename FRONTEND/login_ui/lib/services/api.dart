import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:login_ui/models/kategori_models.dart';
import 'package:login_ui/models/note_models.dart';
import 'package:login_ui/services/auth_store.dart';

class Api {
  static const String BaseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: "http://10.28.189.229:3000",
  );

  //register data
  static register(Map data) async {
    var url = Uri.parse("${BaseUrl}/register");

    try {
      final res = await http.post(url, body: data);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print(data);
      } else {
        print("isi : " + res.body);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //login
  static Future<Map<String, dynamic>> Login(Map<String, String> data) async {
    var url = Uri.parse("${BaseUrl}/login");

    try {
      var res = await http.post(url, body: data);

      if (res.statusCode == 401 || res.statusCode == 404) {
        var status = jsonDecode(res.body);
        print(status);
        return status;
      } else if (res.statusCode == 200) {
        var catchData = jsonDecode(res.body);

        print(catchData);

        await AuthStore.saveTokens(
          catchData['token'],
          catchData['refreshToken'],
        );

        return catchData;
      }
    } catch (err) {
      print(err.toString());
      return {"error": err.toString()};
    }
    return {"error": "Unknown error"};
  }

  //refres-endpoint
  static Future<String?> refreshToken() async {
    final refreshToken = await AuthStore.getRefreshToken();
    if (refreshToken == null) return null;

    var url = Uri.parse("${BaseUrl}/refresh");
    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        await AuthStore.saveToken(data['token']);
        return data['token'];
      }
      return null;
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  //token verification
  static Future<bool> cekAuth(String token) async {
    var url = Uri.parse("${BaseUrl}/auth");

    try {
      var res = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${token}'},
      );
      if (res.statusCode == 200) {
        return true;
      } else {
        var auth = jsonDecode(res.body);
        print(auth);
        return false;
      }
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  //fitur note
  //create note
  static Future<Map<String, dynamic>> createNote(
    Map<String, String> data,
    String token,
  ) async {
    var url = Uri.parse("${BaseUrl}/store-note");

    try {
      var res = await http.post(
        url,
        body: data,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (res.statusCode == 401) {
        final newToken = await refreshToken();
        if (newToken == null) {
          return {"error": "SESSION_EXPIRED"};
        }
        res = await http.post(
          url,
          body: data,
          headers: {'Authorization': 'Bearer $newToken'},
        );
      }

      print(res.body);
      return jsonDecode(res.body);
    } catch (err) {
      print(err.toString());
      return {"error": err.toString()};
    }
  }

  //get note
  static Future<List<NoteModels>> getNote(String token) async {
    List<NoteModels> note = [];
    var url = Uri.parse("${BaseUrl}/get-note");

    try {
      var res = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (res.statusCode == 401) {
        final newToken = await refreshToken();
        if (newToken == null) {
          throw Exception('SESSION_EXPIRED');
        }
        res = await http.get(
          url,
          headers: {'Authorization': 'Bearer $newToken'},
        );
      }

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        data['data'].forEach(
          (value) => {
            note.add(
              NoteModels(
                objectId: value['_id'],
                title: value['title'],
                pref: value['pref'],
                desc: value['description'],
                time: value['time'],
                date: value['date'],
              ),
            ),
          },
        );
        print("ini hasil");
        print(data);
        return note;
      }
    } catch (err) {
      print(err.toString());
      return note = [];
    }

    return note;
  }

  //get note by kategory
  static Future<List<NoteModels>> getNoteByKategory(
    String kategori,
    String token,
  ) async {
    List<NoteModels> note = [];
    var url = Uri.parse(
      "${BaseUrl}/get-noteByKategori",
    ).replace(queryParameters: {'keyword': kategori});

    try {
      var res = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      print(res.statusCode);
      if (res.statusCode == 401) {
        final newToken = await refreshToken();
        if (newToken == null) {
          print("newToken == null");
          throw Exception('SESSION_EXPIRED');
        }
        await AuthStore.saveToken(newToken);
        res = await http.get(
          url,
          headers: {'Authorization': 'Bearer $newToken'},
        );
      }

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        data['data'].forEach(
          (value) => {
            note.add(
              NoteModels(
                objectId: value['_id'],
                title: value['title'],
                pref: value['pref'],
                desc: value['description'],
                time: value['time'],
                date: value['date'],
              ),
            ),
          },
        );
        return note;
      } else {
        throw Exception('Gagal mencari data');
      }
    } catch (err) {
      print(err.toString());
      return note = [];
    }
  }

  //get by name
  static Future<List<NoteModels>> getNoteByName(
    String name,
    String token,
  ) async {
    var url = Uri.parse(
      "${BaseUrl}/get-noteByName",
    ).replace(queryParameters: {'keyword': name});
    List<NoteModels> note = [];

    try {
      var res = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      print(res.statusCode);
      if (res.statusCode == 401) {
        final newToken = await refreshToken();
        if (newToken == null) {
          print("newToken == null");
          throw Exception('SESSION_EXPIRED');
        }
        await AuthStore.saveToken(newToken);
        res = await http.get(
          url,
          headers: {'Authorization': 'Bearer $newToken'},
        );
      }

      if (res.statusCode == 200) {
        print("data berhasil didapat");
        var data = jsonDecode(res.body);
        data['data'].forEach(
          (value) => note.add(
            NoteModels(
              objectId: value['_id'],
              title: value['title'],
              pref: value['pref'],
              desc: value['description'],
              time: value['time'],
              date: value['date'],
            ),
          ),
        );
      } else {
        print("data gagal di dapat");
      }

      return note;
    } catch (err) {
      print(err.toString());
      return note;
    }
  }

  //get by name in kategory
  static Future<List<NoteModels>> getNoteInKategory(
    String kategori,
    String name,
    String token,
  ) async {
    var url = Uri.parse(
      "${BaseUrl}/get-noteByNameAndKategory",
    ).replace(queryParameters: {'title': name, 'kategori': kategori});
    List<NoteModels> note = [];

    try {
      var res = await http.get(
        url,
        headers: {'Authorization': 'Baerer $token'},
      );

      if (res.statusCode == 401) {
        final newToken = await AuthStore.getRefreshToken();
        if (newToken == null) {
          throw Exception('SESSION_EXPIRED');
        }
        await AuthStore.saveToken(newToken);
        var res = await http.get(
          url,
          headers: {'Authorization': 'Baerer $token'},
        );
      }

      if (res.statusCode == 200) {
        print("data berhasil masuk");
        var datas = jsonDecode(res.body);
        datas['data'].forEach(
          (value) => note.add(
            NoteModels(
              objectId: value['_id'],
              title: value['title'],
              pref: value['pref'],
              desc: value['desc'],
              time: value['time'],
              date: value['date'],
            ),
          ),
        );
      } else {
        print("data gagal di terima");
      }

      return note;
    } catch (err) {
      print(err.toString());
      return note;
    }
  }

  //edit
  static Future<void> updateNote(
    String token,
    String objectId,
    Map<String, String> data,
  ) async {
    var url = Uri.parse("${BaseUrl}/update-Note/$objectId");

    try {
      var res = await http.put(
        url,
        body: jsonEncode(data),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (res.statusCode == 401) {
        var newtoken = await AuthStore.getRefreshToken();
        if (newtoken == null) {
          throw new Exception("SESSION_EXPIRED");
        }
        await AuthStore.saveToken(newtoken);
        var res = await http.put(
          url,
          body: jsonEncode(data),
          headers: {'Authorization': 'Bearer $token'},
        );
      }

      if (res.statusCode != 200) {
        throw new Exception('Gagal update note');
      } else {
        print("Data diupdate");
      }
    } catch (err) {
      print(err.toString());
      return;
    }
  }

  //delate
  static Future<void> delateNote(
    String token,
    Set<String> data,
  ) async {
    var url = Uri.parse("${BaseUrl}/delate-Note");

    try {
      var res = await http.delete(
        url,
        body: data,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (res.statusCode == 401) {
        var newtoken = await AuthStore.getRefreshToken();
        if (newtoken == null) {
          throw new Exception("SESSION_EXPIRED");
        }
        await AuthStore.saveToken(newtoken);
        var res = await http.delete(
          url,
          body: data,
          headers: {'Authorization': 'Bearer $token'},
        );
      }

      if (res != 200) {
        throw Exception('Gagal hapus data');
      }
      else{
        print("Data berhasil dihapus");
      }
    } catch (err) {
      print(err.toString());
    }
  }
}

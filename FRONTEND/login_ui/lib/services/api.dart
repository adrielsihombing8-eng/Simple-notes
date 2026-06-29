import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  static const String BaseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: "http://10.49.45.229:3000",
  );

  //register data
  static register(Map data) async{
    var url = Uri.parse("${BaseUrl}/register");

    try{
      final res = await http.post(url, body: data);

      if(res.statusCode == 200){
        var data = jsonDecode(res.body);
        print(data);
      }
      else{
        print("isi : " + res.body);
      }
    }
    catch (e){
      print(e.toString());
    }
  }

  //login 
  static Future<Map<String, dynamic>> Login(Map<String,String> data) async{
    var url = Uri.parse("${BaseUrl}/login");

    try{
      var res = await http.post(url, body: data);

      if(res.statusCode == 401 || res.statusCode == 404){
        var status = jsonDecode(res.body);
        print(status);
        return status;
      }
      else if(res.statusCode == 200){
        var catchData = jsonDecode(res.body);
        print(catchData);
        return catchData;
      }
    }
    catch(err){
      print(err.toString());
      return {"error": err.toString()};
    }
    return {"error": "Unknown error"};
  }

  //token verification
  static Future<bool> cekAuth(String token ) async{
    var url = Uri.parse("${BaseUrl}/auth");

    try{
      var res = await http.get(url, headers: {'Authorization' : 'Bearer ${token}'});
      if(res.statusCode == 200){
        return true;
      }
      else{
        var auth = jsonDecode(res.body);
        print(auth);
        return false;
      }
    }
    catch (err){
      print(err..toString());
      return false;
    }
  }
}

import 'dart:convert';

import 'package:alaev/functions/functions.dart';
import 'package:alaev/functions/server_ip.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;

  bool get isAuth {
    if (_token != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) {
      return false;
    }
    final extractedToken = prefs.getString('token').toString();
    _token = extractedToken;
    notifyListeners();
    return true;
  }

  Future<void> signup(String fullName, String email, String password) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    var passwordMd5 = md5.convert(utf8.encode(password));
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/register',
      headers: headers,
      body: jsonEncode(
        <String, String>{
          "email": email,
          "password": passwordMd5.toString(),
          "fullName": fullName,
          "role": "işveren"
        },
      ),
    );

    if (response.statusCode == 200) {
      print("üyeik oluşturuldu");
    } else {
      showToastError("Email adresiniz veya şifreniz uyuşmamaktadır");
    }
  }

  Future<void> logout() async {
    removeToken();
    _token = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    if (password.length == 0 || email.length == 0) {
      showToastError("Email adresinizi ve şifrenizi girmelisiniz.");
      return false;
    }
    if (!validateEmail(email)) {
      showToastError("Email adresinizi doğru yazdığınızdan emin olun.");
      return false;
    }
    var passwordMd5 = md5.convert(utf8.encode(password));
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/login',
      headers: headers,
      body: jsonEncode(
        <String, String>{"email": email, "password": passwordMd5.toString()},
      ),
    );

    if (response.statusCode == 200) {
      Map<dynamic, dynamic> body = jsonDecode(response.body);
      await setToken(body['token']);
      await setUserRole(body['role']);
      _token = await getToken();
      notifyListeners();
      return true;
    } else {
      showToastError("Email adresiniz veya şifreniz uyuşmamaktadır");
      return false;
    }
  }
}

import 'dart:convert';

import 'package:alaev/functions/functions.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class Auth with ChangeNotifier {
  String _token;
  String _userId;

  Future<void> signup(String fullName, String email, String password) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    var passwordMd5 = md5.convert(utf8.encode(password));
    final response = await http.post(
      'http://10.0.2.2:2000/api/register',
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
      return -1;
    }
  }
}

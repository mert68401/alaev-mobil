import 'package:http/http.dart' as http;
import 'dart:convert';
import 'functions.dart';

Future<void> addCvRequest(
    {String cvNameSurname,
    String cvAge,
    String cvMail,
    String cvPhone,
    String cvPersonalInfo,
    String cvSchool1,
    String cvSchool2,
    String cvExperience1,
    String cvExperience2,
    String cvExperienceInfo,
    String cvReference1,
    String cvReference2,
    String cvLanguage,
    String cvSkillInfo}) async {
  getToken().then((value) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://10.0.2.2:2000/api/setCvPage',
      headers: headers,
      body: jsonEncode(<String, String>{
        "token": value,
        "cvNameSurname": cvNameSurname,
        "cvAge": cvAge,
        "cvMail": cvMail,
        "cvPhone": cvPhone,
        "cvPersonalInfo": cvPersonalInfo,
        "cvSchool1": cvSchool1,
        "cvSchool2": cvSchool2,
        "cvExperience1": cvExperience1,
        "cvExperience2": cvExperience2,
        "cvExperienceInfo": cvExperienceInfo,
        "cvReference1": cvReference1,
        "cvReference2": cvReference2,
        "cvLanguage": cvLanguage,
        "cvSkillInfo": cvSkillInfo,
      }),
    );
    if (response.statusCode == 200) {
      showToastSuccess(jsonDecode(response.body)['message'].toString());
    } else if (response.statusCode == 401) {
      showToastError(jsonDecode(response.body)['message'].toString());
    }
  });
}

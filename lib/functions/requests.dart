import 'package:alaev/functions/server_ip.dart';
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
      'http://' + ServerIP().other + ':2000/api/setCvPage',
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

Future<void> addAdvertisementRequest({
  String adImageUrl,
  String adTitle,
  String adCompanyNumber,
  String adPersonalNumber,
  String adMail,
  String adDiplomaSelectedItem,
  String adContent,
}) async {
  getToken().then((value) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/setJobAdRequest',
      headers: headers,
      body: jsonEncode(<String, String>{
        "token": value,
        "adImageUrl": adImageUrl,
        "adTitle": adTitle,
        "adCompanyNumber": adCompanyNumber,
        "adPersonalNumber": adPersonalNumber,
        "adMail": adMail,
        "adDiplomaSelectedItem": adDiplomaSelectedItem,
        "adContent": adContent
      }),
    );
    if (response.statusCode == 200) {
      showToastSuccess(jsonDecode(response.body)['message'].toString());
    } else if (response.statusCode == 401) {
      showToastError(jsonDecode(response.body)['message'].toString());
    }
  });
}

Future<void> addCompanyAdvertisementRequest({
  dynamic filter,
  String companyAdImageUrl,
  String companyAdTitle,
  String companyAdCompanyNumber,
  String companyAdPersonalNumber,
  String companyAdMail,
  String companyAdContent,
}) async {
  getToken().then((value) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/setCompanyAdRequest',
      headers: headers,
      body: jsonEncode(<String, String>{
        "token": value,
        "filter": filter,
        "companyAdImageUrl": companyAdImageUrl,
        "companyAdTitle": companyAdTitle,
        "companyAdCompanyNumber": companyAdCompanyNumber,
        "companyAdPersonalNumber": companyAdPersonalNumber,
        "companyAdMail": companyAdMail,
        "companyAdContent": companyAdContent
      }),
    );
    if (response.statusCode == 200) {
      showToastSuccess(jsonDecode(response.body)['message'].toString());
    } else if (response.statusCode == 401) {
      showToastError(jsonDecode(response.body)['message'].toString());
    }
  });
}

Future<void> addJobAdvertisementRequest({
  dynamic filter,
  String jobAdImageUrl,
  String jobAdTitle,
  String jobAdCompanyNumber,
  String jobAdPersonalNumber,
  String jobAdMail,
  String jobAdContent,
}) async {
  getToken().then((value) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/setCompanyAdRequest',
      headers: headers,
      body: jsonEncode(<String, String>{
        "token": value,
        "filter": filter,
        "jobAdImageUrl": jobAdImageUrl,
        "jobAdTitle": jobAdTitle,
        "jobAdCompanyNumber": jobAdCompanyNumber,
        "jobAdPersonalNumber": jobAdPersonalNumber,
        "jobAdMail": jobAdMail,
        "jobAdContent": jobAdContent
      }),
    );
    if (response.statusCode == 200) {
      showToastSuccess(jsonDecode(response.body)['message'].toString());
    } else if (response.statusCode == 401) {
      showToastError(jsonDecode(response.body)['message'].toString());
    }
  });
}

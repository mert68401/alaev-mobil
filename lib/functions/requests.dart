import 'package:alaev/functions/server_ip.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'functions.dart';

Future<void> addCvRequest(
    {String cvNameSurname,
    String cvImageUrl,
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
        "cvImageUrl": cvImageUrl,
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

Future<void> addCompanyAdvertisementRequest({
  dynamic filter,
  String companyAdId,
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
        "_id": companyAdId,
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
  String jobAdId,
  String jobAdImageUrl,
  String jobAdTitle,
  String jobAdCompanyNumber,
  String jobAdPersonalNumber,
  String jobAdMail,
  String jobAdContent,
  String jobAdType,
  String jobAdDiploma,
  String city,
  String jobType,
}) async {
  getToken().then((value) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/setJobAdRequest',
      headers: headers,
      body: jsonEncode(<String, String>{
        "token": value,
        "filter": filter,
        "_id": jobAdId,
        "jobAdImageUrl": jobAdImageUrl,
        "jobAdTitle": jobAdTitle,
        "jobAdCompanyNumber": jobAdCompanyNumber,
        "jobAdPersonalNumber": jobAdPersonalNumber,
        "jobAdMail": jobAdMail,
        "jobAdContent": jobAdContent,
        "jobAdType": jobAdType,
        "jobAdDiploma": jobAdDiploma,
        "city": city,
        "jobType": jobType,
      }),
    );
    if (response.statusCode == 200) {
      showToastSuccess(jsonDecode(response.body)['message'].toString());
    } else if (response.statusCode == 401) {
      showToastError(jsonDecode(response.body)['message'].toString());
    }
  });
}

Future<void> updateUserInfo({
  String fullName,
  String email,
  String phone,
  String companyName,
  String companyDiscount,
  String companyAdress,
  String job,
}) async {
  getToken().then((value) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/updateUserInfo',
      headers: headers,
      body: jsonEncode(<String, String>{
        "token": value,
        "fullName": fullName,
        "email": email,
        "phone": phone,
        "companyName": companyName,
        "companyDiscount": companyDiscount,
        "companyAdress": companyAdress,
        "job": job,
      }),
    );
    if (response.statusCode == 200) {
      showToastSuccess(jsonDecode(response.body)['message'].toString());
    } else if (response.statusCode == 401) {
      showToastError(jsonDecode(response.body)['message'].toString());
    }
  });
}

Future<void> forgotPasswordRequest({String email}) async {
  Map<String, String> headers = {"Content-type": "application/json"};
  final response = await http.post(
    'http://' + ServerIP().other + ':2000/api/forgotPassword',
    headers: headers,
    body: jsonEncode(<String, String>{"email": email}),
  );
  if (response.statusCode == 200) {
    showToastSuccess(jsonDecode(response.body)['message'].toString());
  } else if (response.statusCode == 401) {
    showToastError(jsonDecode(response.body)['message'].toString());
  }
}

Future<void> applyJobRequest({
  String jobAdId,
  String userId,
}) async {
  getToken().then((token) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/applyJobAd',
      headers: headers,
      body: jsonEncode(<String, String>{
        "token": token,
        "_id": jobAdId,
      }),
    );
    if (response.statusCode == 200) {
      showToastSuccess(jsonDecode(response.body)['message'].toString());
    } else if (response.statusCode == 401) {
      showToastError(jsonDecode(response.body)['message'].toString());
    }
  });
}

Future<String> getDiscountFromQr(
  String qrContent,
) async {
  Map<String, String> headers = {"Content-type": "application/json"};
  final response = await http.post(
    'http://' + ServerIP().other + ':2000/api/getDiscountFromId',
    headers: headers,
    body: jsonEncode(<String, String>{
      "qrContent": qrContent,
    }),
  );

  if (response.statusCode == 200) {
    return response.body;
  } else if (response.statusCode == 401) {
    return "";
  } else {
    return "";
  }
}

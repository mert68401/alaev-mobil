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
  String companyName,
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
        "companyName": companyName,
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
  String companyName,
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
        "companyName": companyName
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
  String companyPhone,
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
        "companyPhone": companyPhone
      }),
    );
    if (response.statusCode == 200) {
      showToastSuccess(jsonDecode(response.body)['message'].toString());
    } else if (response.statusCode == 401) {
      showToastError(jsonDecode(response.body)['message'].toString());
    }
  });
}

Future<void> updateShowPhone({bool showPhone}) async {
  getToken().then((value) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/updateShowPhone',
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        "token": value,
        "showPhone": showPhone,
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

Future<void> createPost(
  String imageUrl,
  String content,
) async {
  getToken().then((token) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/social-media/createPost',
      headers: headers,
      body: jsonEncode(<String, String>{
        "imageUrl": imageUrl,
        "content": content,
        "token": token,
      }),
    );

    if (response.statusCode == 200) {
      showToastSuccess(jsonDecode(response.body)['message']);
    } else if (response.statusCode == 401) {
      showToastError(jsonDecode(response.body)['message'].toString());
    }
  });
}

Future<dynamic> getAllPosts() async {
  final List<Map<String, dynamic>> postList = [];
  Map<String, String> headers = {"Content-type": "application/json"};
  final response = await http.post(
    'http://' + ServerIP().other + ':2000/api/social-media/getPosts',
    headers: headers,
    body: jsonEncode(
      <String, dynamic>{
        "filter": {},
        "params": {
          "sort": {"createdAt": -1}
        }
      },
    ),
  );

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    body.forEach((element) {
      postList.add({
        "_id": element["_id"],
        "imageUrl": element["imageUrl"],
        "content": element["content"],
        "likesArray": element["likesArray"],
        "commentsArray": element['commentsArray']
      });
    });
    return postList;
    //showToastSuccess(jsonDecode(response.body)['message']);
  } else if (response.statusCode == 401) {
    showToastError(jsonDecode(response.body)['message'].toString());
    return [];
  }
}

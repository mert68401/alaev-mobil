import 'dart:convert';
import 'package:alaev/functions/server_ip.dart';
import 'package:alaev/screens/job_adv/applied_user_job_adv_cv_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AppliedUsersJobAdvScreen extends StatefulWidget {
  static const routeName = '/applied-user-job-adv-screen';
  @override
  State<AppliedUsersJobAdvScreen> createState() {
    return AppState();
  }
}

class AppState extends State<AppliedUsersJobAdvScreen> {
  List<dynamic> appliedUsersList = [];

  Future<void> fetchAppliedUserData(
      {String jobAdId, String cvNameSurname}) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/getAppliedUserData',
      headers: headers,
      body: jsonEncode(
        <String, String>{
          "_id": jobAdId,
          "cvNameSurname": cvNameSurname,
        },
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          appliedUsersList = body;
        });
      }
    }
  }

  void initState() {
    super.initState();
    fetchAppliedUserData();
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    String jobAdId = arguments['_id'];
    fetchAppliedUserData(jobAdId: jobAdId);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              "./assets/images/alaevLogoClean.png",
              scale: 11,
            ),
          ],
        ),
      ),
      body: Container(
        child: ListView.builder(
          reverse: false,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
              child: Card(
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        AppliedUserJobAdvCvScreen.routeName,
                        arguments: {
                          "_id": appliedUsersList[index]["_id"],
                          "cvNameSurname": appliedUsersList[index]
                              ['cvNameSurname'],
                          "cvAge": appliedUsersList[index]['cvAge'],
                          "cvMail": appliedUsersList[index]['cvMail'],
                          "cvPhone": appliedUsersList[index]['cvPhone'],
                          "cvPersonalInfo": appliedUsersList[index]
                              ['cvPersonalInfo'],
                          "cvSchool1": appliedUsersList[index]['cvSchool1'],
                          "cvSchool2": appliedUsersList[index]['cvSchool2'],
                          "cvExperience1": appliedUsersList[index]
                              ['cvExperience1'],
                          "cvExperience2": appliedUsersList[index]
                              ['cvExperience2'],
                          "cvExperienceInfo": appliedUsersList[index]
                              ['cvExperienceInfo'],
                          "cvReference1": appliedUsersList[index]
                              ['cvReference1'],
                          "cvReference2": appliedUsersList[index]
                              ['cvReference2'],
                          "cvLanguage": appliedUsersList[index]['cvLanguage'],
                          "cvSkillInfo": appliedUsersList[index]['cvSkillInfo'],
                          "cvImageUrl": appliedUsersList[index]['cvImageUrl']
                        });
                  },
                  title: Text(appliedUsersList[index]['cvNameSurname']),
                ),
              ),
            );
          },
          itemCount: appliedUsersList.length,
        ),
      ),
    );
  }

  void dispose() {
    super.dispose();
  }
}

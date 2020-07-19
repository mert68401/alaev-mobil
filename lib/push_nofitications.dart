import 'package:alaev/functions/functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    print("12312323asdasd23123");
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      FirebaseMessaging().subscribeToTopic("all");
      _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
        print("onMessage $message");
        showToastSuccess(message['notification']['title']);
      }, onLaunch: (Map<String, dynamic> message) async {
        print("onMessage $message");
      }, onResume: (Map<String, dynamic> message) async {
        print("onMessage $message");
      });

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }
}

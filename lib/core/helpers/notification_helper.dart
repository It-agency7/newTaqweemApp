import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taqwim/core/controllers/main_cubit/main_cubit.dart';

class NotificationService {
  NotificationService._();

  static int idChanel = Random().nextInt(100);

  static void notificationInitialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tone = prefs.getString('tone') ?? 't1';
    String channelKey = prefs.getString('channelKey') ?? 't1';
    print('tone: $tone');
    AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        //'resource://drawable/taqwim_logo.png',
        null,
        [
          NotificationChannel(
            channelKey: channelKey,
            channelName: 'Basic notifications Ne',
            channelDescription: 'Notification channel for basic tests',
            criticalAlerts: true,
            //playSound: true,
            //enableVibration: true,
            importance: NotificationImportance.High,
            soundSource: 'resource://raw/$tone',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
          )
        ]);

    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  //enable/disable notification
  static void enableNotification(bool enable) async {
    //shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('enableNotification', enable);
  }

  //get notification status
  static Future<bool> getNotificationStatus() async {
    //shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('enableNotification') ?? true;
  }

  static Future<bool> createNotification({
    String? title,
    String? body,
    DateTime? date,
    int? id,
  }) async {
    final notificationDate = date ?? DateTime.now().subtract(const Duration(minutes: 10));
    final awesomeNotifications = AwesomeNotifications();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tone = prefs.getString('tone') ?? 't1';
    String channelKey = prefs.getString('channelKey') ?? 't1';
    return awesomeNotifications.createNotification(
      content: NotificationContent(
        id: id ?? Random().nextInt(100),
        channelKey: channelKey,
        title: title,
        body: body,
        displayOnBackground: true,
        displayOnForeground: true,
        notificationLayout: NotificationLayout.BigText,
        autoDismissible: true,
        customSound: 'resource://raw/$tone',
        //icon: 'asset://assets/images/taqwim_logo.png',
      ),
      schedule: NotificationCalendar(
        day: notificationDate.day,
        hour: notificationDate.hour,
        minute: notificationDate.minute,
        second: notificationDate.second,
      ),
    );
  }
}

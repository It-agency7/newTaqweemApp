import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../main.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.containsKey('data')) {
    // Handle data message
    final data = message.data['data'];
  }

  if (message.data.containsKey('notification')) {
    // Handle notification message
    final notification = message.data['notification'];
  }
  // Or do other work.
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  setNotifications() async {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    _firebaseMessaging.requestPermission();

    // handle when app in active state
    forgroundNotification();

    // handle when app running in background state
    backgroundNotification();

    // handle when app completely closed by the user
    terminateNotification();

    // With this token you can test it easily on your phone
    final token =
    _firebaseMessaging.getToken().then((value) => print('Token: $value'));
  }
  forgroundNotification() {
    FirebaseMessaging.onMessage.listen(
          (message) async {
        if (message.data.containsKey('data')) {
          // Handle data message
        }
        if (message.data.containsKey('notification')) {
          // Handle notification message

        }
        // Or do other work.
      },
    );
  }

  backgroundNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) async {
            print("Notification Arrived");
        if (message.data.containsKey('data')) {
          // Handle data message
        }
        if (message.data.containsKey('notification')) {
          // Handle notification message
        }
        // Or do other work.
      },
    );
  }

  terminateNotification() async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      if (initialMessage.data.containsKey('data')) {
        // Handle data message
      }
      if (initialMessage.data.containsKey('notification')) {
        // Handle notification message
      }
      // Or do other work.
    }
  }
}
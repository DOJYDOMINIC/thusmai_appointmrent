import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:http/http.dart' as http;
import '../controller/login_register_otp_api.dart';

Future handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  // showLocalNotification(message.notification!);
  print("Title : ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");

  if (message.notification != null) {
    handleMessage(message);
  }
}

void handleNotification(RemoteMessage message) {
  if (message == null) return;
  // Extract any data from the notification
  final notificationData = message.data;
  // Check if there is a specific action to take based on the notification data
  if (notificationData != null && notificationData['navigateTo'] == 'appointment') {
    // If the notification data specifies to navigate to the details page, push the route
    // Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentPage(),));
  }
}

void handleMessage(RemoteMessage? message) {
  if (message == null) return;
}

void showLocalNotification(RemoteNotification notification, Map<String, dynamic> payload) async {
  final _localNotifications = FlutterLocalNotificationsPlugin();
  const AndroidNotificationDetails androidChannel = AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
    icon: '@drawable/ic_launcher', // Replace with your app's launcher icon
  );

  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidChannel);

  await _localNotifications.show(
    notification.hashCode,
    notification.title,
    notification.body,
    platformChannelSpecifics,
    payload: jsonEncode(payload),
  );
}


Future<void> initNotification(
    FlutterLocalNotificationsPlugin localNotifications) async {
  AndroidInitializationSettings initializationSettingsAndroid =
  const AndroidInitializationSettings('@drawable/ic_launcher');

  var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        print("Body: ${body}");
      });

  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await localNotifications.initialize(initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        print("Notification Response data");
        print("${notificationResponse.id}");
        print("${notificationResponse.payload}");
        var payload = jsonDecode(notificationResponse.payload.toString());
      });
}

Future initPushNotifications() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  // FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

  RemoteMessage? initialMessage =
  await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    handleMessage(initialMessage);
  }

  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);


  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  FirebaseMessaging.onMessage.listen((message) {
    final notification = message.notification;
    if (notification == null) return;
    showLocalNotification(message.notification!, message.data);
    handleMessage(message);
    print("Title : ${message.notification?.title}");
    print("Body: ${message.notification?.body}");
    print("Payload: ${message.data}");
  });
}

class FirebaseApi {

  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fCMToken', fCMToken!);
    var token = prefs.getString("fCMToken");
    print('Token NOT: $token');
    // add token to database
    initPushNotifications();
    initNotification(_localNotifications);
  }

}

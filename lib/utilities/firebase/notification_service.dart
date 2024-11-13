import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ipodaily/utilities/constants/functions.dart';
import 'package:ipodaily/utilities/firebase/core_prefs.dart';
import 'package:ipodaily/utilities/navigation/navigator.dart';

class CoreNotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  static final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> clearFCMToken() async {
    _firebaseMessaging.deleteToken();
  }

  init() async {
    await _firebaseMessaging.requestPermission();
    await getToken();

    const initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_notification');
    final initializationSettingsDarwin = DarwinInitializationSettings(
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // ------- Android notification click handler
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        try {
          final Map payload = json.decode(details.payload ?? "");

          onNotificationClicked(payload: payload);
        } catch (e) {
          logger.e("onDidReceiveNotificationResponse error $e");
        }
      },
    );
  }

  fcmListener({Function()? onTap}) {
    logger.i("Notification Recieved => fcmListener  ");
    logger.i("FCM TOKEN => ${getFCMToken()}  ");

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        logger.i("Notification Recieved => fcmListener > $message ");
        logger.i("FCM TOKEN => ${getFCMToken()}  ");
        createNotification(message);
      },
    );
  }

  onNotificationClicked({required Map payload}) {
    logger.e(payload);
    if (payload.containsKey('path') && payload.containsKey('arguments')) {
      final arguments = json.decode(payload['arguments']);
      logger.i(payload['path']);
      logger.i(arguments);

      if (arguments == null) {
        return;
      }

      MyNavigator.pushNamed(payload['path'], extra: arguments);
    } else if (payload.containsKey('path') == true) {
      MyNavigator.pushNamed(payload['path']);
    }
  }

  void _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    try {
      final Map? payLoadMap = json.decode(payload ?? "");

      if (payLoadMap == null) {
        throw "error";
      }
      onNotificationClicked(payload: payLoadMap);
    } catch (e) {
      logger.e("onDidReceiveNotificationResponse error $e");
    }
  }

  static void createNotification(RemoteMessage message) async {
    try {
      final title = message.notification?.title ?? "Default Title";
      final body = message.notification?.body ?? "Default Body";
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const androidNotificationDetails = AndroidNotificationDetails(
        'pushnotification',
        'pushnotification',
        importance: Importance.max,
        priority: Priority.high,
        // styleInformation: BigPictureStyleInformation(DrawableResourceAndroidBitmap('ic_notification'), largeIcon:  DrawableResourceAndroidBitmap('ic_notification')),
        // largeIcon: DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
      );

      const iosNotificationDetail = DarwinNotificationDetails();

      const notificationDetails = NotificationDetails(
        iOS: iosNotificationDetail,
        android: androidNotificationDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: json.encode(message.data),
      );
    } catch (error) {
      logger.e("Notification Create Error $error");
    }
  }

  Future<void> getToken() async {
    _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    if (token == null) {
      return;
    }
    setFCMToken(token);
  }
}
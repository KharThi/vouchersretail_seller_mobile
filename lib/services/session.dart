import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nyoba/models/seller_model.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

String? selectedNotificationPayload;

class Session {
  static late SharedPreferences data;
  static late FirebaseMessaging messaging;

  static Future init() async {
    data = await SharedPreferences.getInstance();
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      printLog(value!, name: 'Device Token');
      data.setString('device_token', value);
    });

    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
      description:
          'This channel is used for important notifications.', // description
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification: (
              int id,
              String? title,
              String? body,
              String? payload,
            ) async {
              didReceiveLocalNotificationSubject.add(
                ReceivedNotification(
                  id: id,
                  title: title,
                  body: body,
                  payload: payload,
                ),
              );
            });

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      selectedNotificationPayload = payload;
      selectNotificationSubject.add(payload);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      print("message recieved");
      debugPrint("Notif Body ${event.notification!.body}");
      print(event.notification!.android!.imageUrl);
      debugPrint("onMessage : ${event.data.toString()}");
      RemoteNotification? notification = event.notification;
      AndroidNotification? android = event.notification?.android;

      if (notification != null && android != null) {
        if (event.notification!.android!.imageUrl != null) {
          await showBigPictureNotificationURL(
                  event.notification!.android!.imageUrl!)
              .then((value) {
            flutterLocalNotificationsPlugin.show(
                notification.hashCode,
                notification.title,
                notification.body,
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    channel.id,
                    channel.name,
                    icon: 'transparent',
                    channelDescription: channel.description,
                    styleInformation: value,
                    fullScreenIntent: true,
                  ),
                ),
                payload: json.encode(event.data));
          });
        } else {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  icon: 'transparent',
                  channelDescription: channel.description,
                ),
              ),
              payload: json.encode(event.data));
        }
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      print('Init onMessageOpenedApp!');
      debugPrint('onMessageOpenedApp Click ' + message.data.toString());
    });
  }

  static Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  static Future<BigPictureStyleInformation> showBigPictureNotificationURL(
      String url) async {
    final ByteArrayAndroidBitmap largeIcon =
        ByteArrayAndroidBitmap(await _getByteArrayFromUrl(url));
    final ByteArrayAndroidBitmap bigPicture =
        ByteArrayAndroidBitmap(await _getByteArrayFromUrl(url));

    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(bigPicture, largeIcon: largeIcon);

    return bigPictureStyleInformation;
  }

  Future saveUser(Seller seller) async {
    data.setBool('isLogin', true);
    data.setInt("id", seller.id!);
    data.setString("sellerName", seller.sellerName ?? '');
    data.setString("userInfoId", seller.userInfoId.toString());
    data.setString("email", seller.userInfo!.email!);
    data.setString("avatarLink", seller.userInfo!.avatarLink.toString());
    data.setString("userName", seller.userInfo!.userName!);
    data.setString("role", seller.userInfo!.role!);
    data.setString("phoneNumber", seller.userInfo!.phoneNumber!);
    data.setString("createAt", seller.userInfo!.createAt ?? '');
    data.setString("updateAt", seller.userInfo!.updateAt ?? '');
    data.setString("deleteAt", seller.userInfo!.deleteAt ?? '');
    data.setString("status", seller.userInfo!.status!);
    data.setString("commissionRate", seller.commissionRate.toString());
    data.setString("rank", jsonEncode(seller.rank));
    data.setString("orders", seller.orders.toString());
    data.setInt("exp", seller.exp!);
  }

  void removeUser() async {
    data.setBool('isLogin', false);

    data.remove("id");
    data.remove("sellerName");
    data.remove("userInfoId");
    data.remove("email");
    data.remove("avatarLink");
    data.remove("userName");
    data.remove("role");
    data.remove("phoneNumber");
    data.remove("createAt");
    data.remove("updateAt");
    data.remove("deleteAt");
    data.remove("status");
    data.remove("commissionRate");
    data.remove("rank");
    data.remove("orders");
    data.remove("exp");
    // data.remove("busyLevel");

    data.remove("id");
    data.remove("username");
    data.remove("avatarLink");
    data.remove("email");
    data.remove("phoneNumber");
    data.remove("createAt");
    data.remove("updateAt");
    data.remove("deleteAt");
    data.remove("status");
    data.remove("role");
  }

  Future<String?> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    return token;
  }
}

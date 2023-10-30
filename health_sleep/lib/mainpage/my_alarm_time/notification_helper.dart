import 'package:flutter/material.dart';
//時間になったらバックグラウンドで音楽を鳴らすため
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
//時間になったらローカル通知を出すため
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//ローカル通知で使うMethodChannelのため
import 'package:flutter/services.dart';
//ローカル通知で使うStreamControllerのため
import 'dart:async';
//音楽を慣らすため
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
//ローカル通知の時間をセットするためタイムゾーンの定義が必要
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
//kIsWeb(Web判定)を使うため
import 'package:flutter/foundation.dart';
//Platform判定のため
import 'dart:io';
import 'dart:io';
import 'dart:ui';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'NotificationService.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'sql_helper.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

//ローカル通知のための準備
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
String? selectedNotificationPayload;
final StreamController didReceiveLocalNotificationStream =
    StreamController.broadcast();
final StreamController selectNotificationStream = StreamController.broadcast();
const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

class NotificationHelper {
  Future<void> RefreshNotification() async {
    late LocalNotificationService service;
    service = LocalNotificationService();

    List<Map<String, dynamic>> _settings = [];

    final data = await NotificationSQLHelper.getItems();
    _settings = data;
    await flutterLocalNotificationsPlugin.cancelAll();
    print("Setting notification");
    for (int n = 0; n < _settings.length; n++) {
      if (_settings[n]['nt_state'] == 1) {
        for (int i = 1; i <= 31; i++) {
          await service.scheduledMonthlyNotificationDetails(
            day: i,
            hour: _settings[n]['nt_hour'],
            minutes: _settings[n]['nt_minutes'],
            id: 100 * n + i,
            Title: "",
            Details: "",
          );
        }
      }
    }
  }
}

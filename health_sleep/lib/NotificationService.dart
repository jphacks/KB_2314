import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final _localNotificationService = FlutterLocalNotificationsPlugin();

class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('mipmap/ic_launcher');

    DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );

    _localNotificationService.initialize(initializationSettings);
  }

  onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print("ID: $id");
  }

  onSelectNotification(String? payload) {
    print("Payload: $payload");

    if (payload != null && payload.isNotEmpty) {
      onNotificationClick.add(payload);
    }
  }

  _notificationDetails() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "channel_id",
      "channel_name",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );

    DarwinNotificationDetails iOSNotificationDetails =
        const DarwinNotificationDetails();

    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSNotificationDetails,
    );
  }

  showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();

    await _localNotificationService.show(id, title, body, details);
  }

  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  tz.TZDateTime _monthlyTZ(int day, int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      day,
      hour,
      minutes,
    );
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  scheduledNotification({
    required int hour,
    required int minutes,
    required int id,
  }) async {
    await _localNotificationService.zonedSchedule(
      id,
      "It's time to drink water!",
      'After drinking, touch the cup to confirm',
      _convertTime(hour, minutes),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id ',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          // sound: RawResourceAndroidNotificationSound(sound),
        ),
        // iOS: IOSNotificationDetails(sound: '$sound.mp3'),
        iOS: const DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // 毎日同じ時間に
      // matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime // 毎週同じ時間に
      payload: 'It could be anything you pass',
    );
  }

  //指定日時に通知
  scheduledMonthlyNotification({
    required int day,
    required int hour,
    required int minutes,
    required int id,
  }) async {
    await _localNotificationService.zonedSchedule(
      id,
      "It's time to drink water!",
      'After drinking, touch the cup to confirm',
      _monthlyTZ(day, hour, minutes),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id ',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          // sound: RawResourceAndroidNotificationSound(sound),
        ),
        // iOS: IOSNotificationDetails(sound: '$sound.mp3'),
        iOS: const DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime, // 毎月同じ時間に
      payload: 'It could be anything you pass',
    );
  }

  //内容を指定して指定日時に通知
  scheduledMonthlyNotificationDetails({
    required int day,
    required int hour,
    required int minutes,
    required int id,
    required String Title,
    required String Details,
  }) async {
    await _localNotificationService.zonedSchedule(
      id,
      Title,
      Details,
      _monthlyTZ(day, hour, minutes),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'Centum01',
          'CentumRemind',
          channelDescription: 'Remind Passion!!',
          importance: Importance.max,
          priority: Priority.high,
          // sound: RawResourceAndroidNotificationSound(sound),
        ),
        // iOS: IOSNotificationDetails(sound: '$sound.mp3'),
        iOS: const DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime, // 毎月同じ時間に
      payload: 'It could be anything you pass',
    );
    if (day == 8) {
      print("8");
    }
  }

  showNotificationWithPayload({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final details = await _notificationDetails();

    await _localNotificationService.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

// 毎分通知
  Future<void> regularSchedule() async {
    final platformChannelSpecifics = await _notificationDetails();
    await _localNotificationService.periodicallyShow(0, 'repeating title',
        'repeating body', RepeatInterval.everyMinute, platformChannelSpecifics,
        androidAllowWhileIdle: true);
  }

// 毎週同じ時刻に通知（バックグラウンドも可）
  scheduledNotificationPerDay({
    required timelist,
  }) async {
    final platformChannelSpecifics = await _notificationDetails();
    for (int i = 0; i < timelist.length; i++) {
      await _localNotificationService.zonedSchedule(
        i + 1000, // id 重複したら上書き
        "薬を飲む時間です!",
        '',
        _convertTime(int.parse(timelist[i]['hour'].toString()),
            int.parse(timelist[i]['minutes'].toString())),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'your channel id ',
            'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            // sound: RawResourceAndroidNotificationSound(sound),
          ),
          // iOS: IOSNotificationDetails(sound: '$sound.mp3'),
          iOS: const DarwinNotificationDetails(),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: 'payload!',
      );
    }
  }

  void cancelAllNotifications() => _localNotificationService.cancelAll();
}

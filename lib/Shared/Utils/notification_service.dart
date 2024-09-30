import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService
{ 
  final FlutterLocalNotificationsPlugin  _flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings _androidInitializationSettings = const AndroidInitializationSettings('logo');

  void initialiseNotifications() async{
    InitializationSettings  initializationSettings=
    InitializationSettings(
      android: _androidInitializationSettings
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);

  }
  void sendNotifications(String title,String body) async
  {
    AndroidNotificationDetails _androidNotificationDetails= AndroidNotificationDetails(
        'channelId',
        'channelName',
        'channelDescription',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(
          body,
          htmlFormatBigText: true, // Use true for HTML formatting
          contentTitle: title,
        ),
        );
    NotificationDetails  _notificationDetails=NotificationDetails(android: _androidNotificationDetails);


  await  _flutterLocalNotificationsPlugin.show(0, title, body, _notificationDetails);

  }
/*   void scheduleNotifications(String title,String body) async
  {
    AndroidNotificationDetails _androidNotificationDetails=const AndroidNotificationDetails(
        'channelId',
        'channelName',
        'channelDescription',
        importance: Importance.max,
        priority: Priority.high,
        );
    NotificationDetails  _notificationDetails=NotificationDetails(
      android: _androidNotificationDetails
    );


  await  _flutterLocalNotificationsPlugin.periodicallyShow(0, title, body, RepeatInterval.everyMinute, _notificationDetails);

  } */
   void scheduleNotifications(String title,String desc) async {
        tz.initializeTimeZones();
        AndroidNotificationDetails _androidNotificationDetails=const AndroidNotificationDetails(
        'channelId',
        'channelName',
        'channelDescription',
        importance: Importance.max,
        priority: Priority.high,
        );
    NotificationDetails  _notificationDetails=NotificationDetails(
      android: _androidNotificationDetails
    );
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        desc,
        tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1)),
       _notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
   Future<void> cancelNotifications() async {
    await _flutterLocalNotificationsPlugin.cancel(0);
  }
}
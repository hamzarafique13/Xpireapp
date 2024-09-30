import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:workmanager/workmanager.dart';
import 'package:Xpiree/Shared/Model/shared_model.dart';
import 'package:Xpiree/Shared/UI/SplashScreen.dart';
import 'package:Xpiree/Shared/UI/theme.dart';
import 'package:Xpiree/Shared/Utils/CommonConfig.dart';
import 'package:Xpiree/Shared/Utils/SessionMangement.dart';
import 'package:Xpiree/Shared/Utils/notification_service.dart';
import 'package:http/http.dart' as http;

/* Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final NotificationService _notificationService=NotificationService();
    _notificationService.initialiseNotifications();
   _notificationService.scheduleNotifications("Title","Description"); 
} */
//this is the name given to the background fetch
const simplePeriodicTask = "simplePeriodicTask";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher,
      isInDebugMode:
          false); //to true if still in testing lev turn it to false whenever you are launching the app
  Workmanager().registerPeriodicTask("5", simplePeriodicTask,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      frequency: const Duration(minutes: 15), //when should it check the link
      initialDelay:
          const Duration(seconds: 5), //duration before showing the notification
      constraints: Constraints(
        networkType: NetworkType.connected,
      ));
  
  runApp(const MyApp());
}


void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    String? userId = await _sm.getUserId();

    final response = await http.get(
        Uri.parse(baseUrl + 'Client/getPushNotificationList?userId=' + userId!),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token!,
        });
    List _list;
    if (response.statusCode == 200) {
      if (response.body != "null") {
        _list = jsonDecode(response.body);
        _list
            .map<PushNotificationVm>(
                (json) => PushNotificationVm.fromJson(json))
            .toList();
        for (int i = 0; i < _list.length; i++) {
          if (_list[i] != null) {
            final NotificationService _notificationService =
                NotificationService();
            _notificationService.initialiseNotifications();
            _notificationService.sendNotifications(
                _list[i].title.toString(), _list[i].description.toString());
          }
        }
      }
    }
    /*    getPushNotifyList().then((response) {

                for(int i=0;i<response!.length;i++)
                  {
                    if(response[i]!=null)
                    {
                        final NotificationService _notificationService=NotificationService();
                      _notificationService.initialiseNotifications();
                      _notificationService.sendNotifications(response[i].title.toString(),response[i].description.toString());

                    }
                      

                  }
            });  */

    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Xpiree',
      theme: basicTheme(),
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}

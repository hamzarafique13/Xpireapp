// ignore_for_file: import_of_legacy_library_into_null_safe, file_names

import 'dart:io';

import 'package:Xpiree/Shared/Utils/CommonConfig.dart';
import 'package:Xpiree/Shared/Utils/SessionMangement.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:signalr_core/signalr_core.dart';

 String getDateTimeFormate(String date) {
  DateTime now = DateTime.parse(date);
  String formattedDate = DateFormat('MMM dd, yyyy hh:mm:ss').format(now);
  return formattedDate;
}

String getDateFormate(String date) {
  DateTime now = DateTime.parse(date);
  String formattedDate = DateFormat('MMM dd, yyyy').format(now);
  return formattedDate;
}
String getDateMonthFormate(String date) {
  DateTime now = DateTime.parse(date);
  String formattedDate = DateFormat('MMM').format(now);
  return formattedDate;
}
String getTimeFormate(String time) {
  DateTime now = DateTime.parse(time);
  String formattedTime = DateFormat('hh:mm a').format(now);
  return formattedTime;
} 
String getUserFirstLetetrs(String text) {
  String  userShortName="";
  var data= text.split(" ");
  
  int counter=data.length>1?2:1;
        for(int i=0;i<counter;i++)
        {
          if(data[i].isNotEmpty)
          {
            userShortName=userShortName+data[i][0];
          }
          

        }
  return userShortName;
} 

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}
String capitalize(String value) {
  if(value.trim().isEmpty) 
  {
    return "";

  }
    var data= value.split(" ");

    String reply=""; 

      for(int i=0;i<data.length;i++)
      {
        reply=reply+("${data[i][0].toUpperCase()}${data[i].substring(1).toLowerCase()}");

      }
      return reply;
 // return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}

Future<void> getNotificationCount() async {
  EasyLoading.dismiss();
  /*  SessionMangement _sm = SessionMangement();
  String? token = await _sm.getToken(); */
  final connection = HubConnectionBuilder()
      .withUrl(
        notificationHubUrl,
        HttpConnectionOptions(
            //accessTokenFactory: () async => token,
            client: IOClient(
                HttpClient()..badCertificateCallback = (x, y, z) => true),
            logging: (level, message) => print(message),
            skipNegotiation: true,
            transport: HttpTransportType.webSockets),
      )
      .build();

  await connection.start();

  connection.on('SendNotification', (message) {
    SessionMangement _sm = SessionMangement();
    _sm.setNewNotify(true);
  });
  connection.onclose((error) {
    getNotificationCount();
  });
}

/* String getDateFormate(String date) {
  DateTime now = DateTime.parse(date);
  String formattedDate = DateFormat('MMM, yyyy').format(now);
  return formattedDate;
} */
/* Future<int> getUserIdByToken() async {
  try {
    String token = await getRefreshUserToken();
    final response = await http.get(baseUrl + 'm_GetUserID', headers: {
      'Authorization': 'Bearer ' + token,
    });
    int _list;
    if (response.statusCode == 200) {
      _list = jsonDecode(response.body);
      return _list;
    } else {
      throw Exception('Failed to load Alumni Major Role');
    }
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<bool> checkInternet() async {
  return await DataConnectionChecker().hasConnection;
} */

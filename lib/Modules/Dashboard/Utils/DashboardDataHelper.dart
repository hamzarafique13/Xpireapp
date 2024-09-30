// ignore_for_file: import_of_legacy_library_into_null_safe,file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Xpiree/Modules/Dashboard/Model/DashboardModel.dart';
import 'package:Xpiree/Shared/Utils/CommonConfig.dart';
import 'package:Xpiree/Shared/Utils/SessionMangement.dart';

Future<DocumentVM?> getActiveDocDataTable() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(baseUrl + 'Client/GetActiveDocDataTable?filter=1'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token!,
        });
    if (response.statusCode == 200) {
      if (response.body != "null") {
        Map data = jsonDecode(response.body);
        var _data = DocumentVM.fromJson(data["result"]);
        return _data;
      }
      return null;
    } else {
      throw Exception('Failed to load Job Status');
    }
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<DocumentVM?> getExpiringDocDataTable() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(baseUrl + 'Client/GetExpiringDocDataTable?filter=1'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token!,
        });
    if (response.statusCode == 200) {
      if (response.body != "null") {
        Map data = jsonDecode(response.body);
        var _data = DocumentVM.fromJson(data["result"]);
        return _data;
      }
      return null;
    } else {
      throw Exception('Failed to load Job Status');
    }
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<DocumentVM?> getExpiredDocDataTable() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(baseUrl + 'Client/GetExpiredDocDataTable?filter=1'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token!,
        });
    if (response.statusCode == 200) {
      if (response.body != "null") {
        Map data = jsonDecode(response.body);
        var _data = DocumentVM.fromJson(data["result"]);
        return _data;
      }
      return null;
    } else {
      throw Exception('Failed to load Job Status');
    }
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<DocumentVM?> getExpiredDocDataTableBookmark() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(baseUrl + 'Client/GetExpiredDocDataTable?filter=2'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token!,
        });
    if (response.statusCode == 200) {
      if (response.body != "null") {
        Map data = jsonDecode(response.body);
        var _data = DocumentVM.fromJson(data["result"]);
        return _data;
      }
      return null;
    } else {
      throw Exception('Failed to load Job Status');
    }
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<DocumentVM?> getActiveDocDataTableBookmarkdata() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(baseUrl + 'Client/GetActiveDocDataTable?filter=2'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token!,
        });
    if (response.statusCode == 200) {
      if (response.body != "null") {
        Map data = jsonDecode(response.body);
        var _data = DocumentVM.fromJson(data["result"]);
        return _data;
      }
      return null;
    } else {
      throw Exception('Failed to load Job Status');
    }
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<DocumentVM?> getExpiringDocDataTableBookmark() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(baseUrl + 'Client/GetExpiringDocDataTable?filter=2'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token!,
        });
    if (response.statusCode == 200) {
      if (response.body != "null") {
        Map data = jsonDecode(response.body);
        var _data = DocumentVM.fromJson(data["result"]);
        return _data;
      }
      return null;
    } else {
      throw Exception('Failed to load Job Status');
    }
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<DashboardCountVm> getDashboardCounts() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    DashboardCountVm _data = DashboardCountVm();
    final response = await http
        .get(Uri.parse(baseUrl + 'Client/GetDashboardCounts'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token!,
    });
    if (response.statusCode == 200) {
      if (response.body != "null") {
        Map data = jsonDecode(response.body);
        _data = DashboardCountVm.fromJson(data["result"]);
        return _data;
      }
    }
    return _data;
  } catch (error) {
    EasyLoading.dismiss();
    rethrow;
  }
}

Future<String?> addBookmark(String id, bool isbookmark) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
      Uri.parse(baseUrl +
          'Client/addBookmark?docId=' +
          id +
          '&bookmark=' +
          isbookmark.toString()),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return data["result"];
    }
    return null;
  } catch (error) {
    EasyLoading.dismiss();
    throw Exception('Failed');
  }
}

Future<List<NotificationVm>?> getNotificationDataTable() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http
        .get(Uri.parse(baseUrl + 'Client/getNotifyDataTable'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token!,
    });
    List _list;
    if (response.statusCode == 200) {
      if (response.body != "null") {
        Map data = jsonDecode(response.body);

        _list = data["result"];
        return _list
            .map<NotificationVm>((json) => NotificationVm.fromJson(json))
            .toList();
      }
    }
    return null;
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<String?> readSingleNotify(String notifyId) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
      Uri.parse(baseUrl + 'Client/ReadSingleNotify?notifyId=' + notifyId),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  } catch (error) {
    EasyLoading.dismiss();
    throw Exception('Failed');
  }
}

Future<String?> readMultiNotify() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
      Uri.parse(baseUrl + 'Client/ReadMultiNotify'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  } catch (error) {
    EasyLoading.dismiss();
    throw Exception('Failed');
  }
}

Future<String?> clearSingleNotify(String notifyId) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
      Uri.parse(baseUrl + 'Client/clearSingleNotify?notifyId=' + notifyId),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  } catch (error) {
    EasyLoading.dismiss();
    throw Exception('Failed');
  }
}

Future<String?> clearMultiNotify() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
      Uri.parse(baseUrl + 'Client/clearMultiNotify'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  } catch (error) {
    EasyLoading.dismiss();
    throw Exception('Failed');
  }
}

Future<String?> gotItBtn() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
      Uri.parse(baseUrl + 'Account/welcomeMsg'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  } catch (error) {
    EasyLoading.dismiss();
    throw Exception('Failed');
  }
}

Future<String?> setAppWorkType(int appWorkType) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
      Uri.parse(baseUrl +
          'Account/setAppWorkType?appWorkType=' +
          appWorkType.toString()),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  } catch (error) {
    EasyLoading.dismiss();
    throw Exception('Failed');
  }
}

Future<String?> acceptRejectInvitation(
    String notifyId, String senderId, int acceptStatus) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
      Uri.parse(baseUrl +
          'Client/acceptRejectInvitation?notifyId=' +
          notifyId +
          '&senderId=' +
          senderId +
          '&acceptStatus=' +
          acceptStatus.toString()),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  } catch (error) {
    EasyLoading.dismiss();
    throw Exception('Failed');
  }
}
